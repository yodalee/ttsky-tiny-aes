# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

"""End-to-end AES tests through the TinyTapeout pin-level interface.

Pin map:
    ui_in[0]       rising edge: submit the byte currently on uio_in
    ui_in[1]       rising edge: accept the byte currently on uio_out
    ui_in[6]       decrypt select
    ui_in[5:4]     AES key size (00/01/10 = 128/192/256 bits)
    uo_out[0]      input ready
    uo_out[1]      output valid

The wrapper synchronizes both strobe bits.  The helpers keep uio_in stable
throughout an input transfer, so AES data and keys use uio_in exclusively;
the AES result is read exclusively from uio_out.
"""

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ReadOnly, RisingEdge


DATA = bytes.fromhex("00112233445566778899aabbccddeeff")
KEY_LEVEL = {16: 0b00, 24: 0b01, 32: 0b10}

EXPECTED = {
    16: bytes.fromhex("69c4e0d86a7b0430d8cdb78070b4c55a"),
    24: bytes.fromhex("dda97ca4864cdfe06eaf70a0ec0d7191"),
    32: bytes.fromhex("8ea2b7ca516745bfeafc49904b496089"),
}

DECRYPTION_KEY_STATE = {
    16: bytes.fromhex("13111d7fe3944a17f307a78b4d2b30c5"),
    24: bytes.fromhex("a223800fd8aeda32a4970a331a78dc09c418c271e3a41d5d"),
    32: bytes.fromhex("4e5a6699a9f24fe07e572baacdf8cdea24fc79ccbf0979e9371ac23c6d68de36"),
}

INPUT_STROBE = 0x01
OUTPUT_STROBE = 0x02
INPUT_READY = 0x01
OUTPUT_VALID = 0x02


def pin(value):
    return int(value)


async def reset(dut, decrypt, key_length):
    """Reset the wrapper and program static AES configuration pins."""
    dut.ena.value = 1
    dut.ui_in.value = (int(decrypt) << 6) | (KEY_LEVEL[key_length] << 4)
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)
    await ReadOnly()


async def wait_for(dut, mask, name, limit=10_000):
    for _ in range(limit):
        await RisingEdge(dut.clk)
        await ReadOnly()
        if pin(dut.uo_out.value) & mask:
            # Leave the read-only phase before returning to a helper that
            # drives the next uio/ui_in transaction.
            await RisingEdge(dut.clk)
            return
    raise AssertionError(f"timed out waiting for {name}")


async def send_byte(dut, config, value):
    """Send one input byte over uio_in when uo_out[0] is asserted."""
    await wait_for(dut, INPUT_READY, "input ready")
    dut.uio_in.value = value
    dut.ui_in.value = config | INPUT_STROBE

    # Two synchronizer stages create i_valid; AesTop samples it one edge later.
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.ui_in.value = config
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)


async def receive_byte(dut, config):
    """Accept and return one valid byte from uio_out."""
    await wait_for(dut, OUTPUT_VALID, "output valid")
    dut.ui_in.value = config | OUTPUT_STROBE

    # The synchronized o_ready pulse is visible after the second edge.  Save
    # the current output before the following edge advances the AES state.
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    await ReadOnly()
    value = pin(dut.uio_out.value)
    assert pin(dut.uio_oe.value) == 0xFF, "uio_out must drive valid AES output"
    await RisingEdge(dut.clk)
    dut.ui_in.value = config
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    return value


async def run_aes(dut, decrypt, input_bytes, key_bytes):
    config = (int(decrypt) << 6) | (KEY_LEVEL[len(key_bytes)] << 4)
    await reset(dut, decrypt, len(key_bytes))
    for value in input_bytes + key_bytes:
        await send_byte(dut, config, value)
    return bytes([await receive_byte(dut, config) for _ in range(16)])


async def check_aes(dut, decrypt, key_length):
    if decrypt:
        input_bytes = EXPECTED[key_length]
        key_bytes = DECRYPTION_KEY_STATE[key_length]
        expected = DATA
    else:
        input_bytes = DATA
        key_bytes = bytes(range(key_length))
        expected = EXPECTED[key_length]
    actual = await run_aes(dut, decrypt, input_bytes, key_bytes)
    direction = "decrypt" if decrypt else "encrypt"
    assert actual == expected, (
        f"AES-{key_length * 8} {direction} returned {actual.hex()}, "
        f"expected {expected.hex()}"
    )


@cocotb.test()
async def test_aes128_encrypt(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await check_aes(dut, decrypt=False, key_length=16)


@cocotb.test()
async def test_aes192_encrypt(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await check_aes(dut, decrypt=False, key_length=24)


@cocotb.test()
async def test_aes256_encrypt(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await check_aes(dut, decrypt=False, key_length=32)


@cocotb.test()
async def test_aes128_decrypt(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await check_aes(dut, decrypt=True, key_length=16)


@cocotb.test()
async def test_aes192_decrypt(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await check_aes(dut, decrypt=True, key_length=24)


@cocotb.test()
async def test_aes256_decrypt(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await check_aes(dut, decrypt=True, key_length=32)
