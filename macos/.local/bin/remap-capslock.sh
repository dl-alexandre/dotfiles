#!/bin/bash
# Caps Lock (0x39) → Delete/Backspace (0x2A)
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x70000002A}]}'
