meta:
  id: shell_link
  endian: le
  file-extension: lnk
doc: "ShellLinkHeader and associated structures for parsing Windows Shell Link (.lnk) files."

seq:
  - id: header
    type: shell_link_header
  - id: link_target_id_list
    type: link_target_id_list
    if: header.link_flags.has_link_target_id_list
  - id: link_info
    type: link_info
    if: header.link_flags.has_link_info
  - id: string_data
    type: string_data
  - id: extra_data
    type: extra_data

types:
  shell_link_header:
    doc: "ShellLinkHeader structure."
    seq:
      - id: header_size
        type: u4
        doc: "Size of the header"
      - id: link_clsid
        size: 16
        doc: "Class identifier of the link"
      - id: link_flags
        type: link_flags
      - id: file_attributes
        type: file_attributes
      - id: creation_time
        type: u8
        doc: "Creation time of the target"
      - id: access_time
        type: u8
        doc: "Last access time of the target"
      - id: write_time
        type: u8
        doc: "Last modification time of the target"
      - id: file_size
        type: u4
        doc: "Size of the target file in bytes"
      - id: icon_index
        type: s4
        doc: "Index of the icon in the associated icon file."
      - id: show_command
        type: u4
        enum: show_command_enum
        doc: "Show command of the window when opened"
      - id: hot_key
        type: hot_key_flags
      - id: reserved1
        type: u2
        doc: "Reserved for future use"
      - id: reserved2
        type: u4
        doc: "Reserved for future use"
      - id: reserved3
        type: u4
        doc: "Reserved for future use"

  link_flags:
    seq:
      - id: flags
        type: u4
    instances:
      has_link_target_id_list:
        value: (flags & 0x00000001) != 0
      has_link_info:
        value: (flags & 0x00000002) != 0
      has_name:
        value: (flags & 0x00000004) != 0
      has_relative_path:
        value: (flags & 0x00000008) != 0
      has_working_dir:
        value: (flags & 0x00000010) != 0
      has_arguments:
        value: (flags & 0x00000020) != 0
      has_icon_location:
        value: (flags & 0x00000040) != 0
      is_unicode:
        value: (flags & 0x00000080) != 0
      force_no_link_info:
        value: (flags & 0x00000100) != 0
      has_exp_string:
        value: (flags & 0x00000200) != 0
      run_in_separate_process:
        value: (flags & 0x00000400) != 0
      unused1:
        value: (flags & 0x00000800) != 0
      has_darwin_id:
        value: (flags & 0x00001000) != 0
      run_as_user:
        value: (flags & 0x00002000) != 0
      has_exp_icon:
        value: (flags & 0x00004000) != 0
      no_pidl_alias:
        value: (flags & 0x00008000) != 0
      unused2:
        value: (flags & 0x00010000) != 0
      run_with_shim_layer:
        value: (flags & 0x00020000) != 0
      force_no_link_track:
        value: (flags & 0x00040000) != 0
      enable_target_metadata:
        value: (flags & 0x00080000) != 0
      disable_link_path_tracking:
        value: (flags & 0x00100000) != 0
      disable_known_folder_tracking:
        value: (flags & 0x00200000) != 0
      disable_known_folder_alias:
        value: (flags & 0x00400000) != 0
      allow_link_to_link:
        value: (flags & 0x00800000) != 0
      unalias_on_save:
        value: (flags & 0x01000000) != 0
      prefer_environment_path:
        value: (flags & 0x02000000) != 0
      keep_local_id_list_for_unc_target:
        value: (flags & 0x04000000) != 0

  file_attributes:
    seq:
      - id: attributes
        type: u4
    instances:
      readonly:
        value: (attributes & 0x00000001) != 0
      hidden:
        value: (attributes & 0x00000002) != 0
      system:
        value: (attributes & 0x00000004) != 0
      reserved1:
        value: (attributes & 0x00000008) != 0
      directory:
        value: (attributes & 0x00000010) != 0
      archive:
        value: (attributes & 0x00000020) != 0
      reserved2:
        value: (attributes & 0x00000040) != 0
      normal:
        value: (attributes & 0x00000080) != 0
      temporary:
        value: (attributes & 0x00000100) != 0
      sparse_file:
        value: (attributes & 0x00000200) != 0
      reparse_point:
        value: (attributes & 0x00000400) != 0
      compressed:
        value: (attributes & 0x00000800) != 0
      offline:
        value: (attributes & 0x00001000) != 0
      not_content_indexed:
        value: (attributes & 0x00002000) != 0
      encrypted:
        value: (attributes & 0x00004000) != 0

  hot_key_flags:
    seq:
      - id: low_byte
        type: u1
        doc: "Virtual key code"
        enum: virtual_key_codes
      - id: high_byte
        type: u1
        doc: "Modifier keys"
        enum: hot_key_modifiers

  link_target_id_list:
    doc: "Specifies the target of the link."
    seq:
      - id: len_id_list
        type: u2
        doc: "Size of the IDList in bytes"
      - id: id_list
        size: len_id_list
        type: id_list

  id_list:
    seq:
      - id: item_id_list
        type: item_id
        repeat: until
        repeat-until: _.size == 0

  item_id:
    seq:
      - id: size
        type: u2
      - id: data
        size: size - 2
        if: size > 2

  link_info:
    doc: "LinkInfo structure."
    seq:
      - id: link_info_size
        type: u4
        doc: "Size of the LinkInfo structure."
      - id: link_info_header_size
        type: u4
        doc: "Size of the LinkInfo header."
      - id: link_info_flags
        type: link_info_flags
      - id: volume_id_offset
        type: u4
        doc: "Location of the VolumeID field."
      - id: local_base_path_offset
        type: u4
        doc: "Location of the LocalBasePath field."
      - id: common_network_relative_link_offset
        type: u4
        doc: "Location of the CommonNetworkRelativeLink field."
      - id: common_path_suffix_offset
        type: u4
        doc: "Location of the CommonPathSuffix field."
      - id: local_base_path_offset_unicode
        type: u4
        if: link_info_header_size >= 0x00000024
        doc: "Location of the LocalBasePathUnicode field."
      - id: common_path_suffix_offset_unicode
        type: u4
        if: link_info_header_size >= 0x00000024
        doc: "Location of the CommonPathSuffixUnicode field."
      - id: remainder
        size: link_info_size - link_info_header_size
    instances:
      volume_id:
        pos: _io.pos - link_info_size + volume_id_offset
        type: volume_id
        if: link_info_flags.volume_id_and_local_base_path
      local_base_path:
        pos: _io.pos - link_info_size + local_base_path_offset
        type:
          switch-on: _root.header.link_flags.is_unicode
          cases:
            true: strz_unicode
            false: strz_utf8
        if: link_info_flags.volume_id_and_local_base_path
      common_network_relative_link:
        pos: _io.pos - link_info_size + common_network_relative_link_offset
        type: common_network_relative_link
        if: link_info_flags.common_network_relative_link_and_path_suffix
      common_path_suffix:
        pos: _io.pos - link_info_size + common_path_suffix_offset
        type:
          switch-on: _root.header.link_flags.is_unicode
          cases:
            true: strz_unicode
            false: strz_utf8
      local_base_path_unicode:
        pos: _io.pos - link_info_size + local_base_path_offset_unicode
        type: strz_unicode
        if: link_info_flags.volume_id_and_local_base_path and link_info_header_size >= 0x00000024
      common_path_suffix_unicode:
        pos: _io.pos - link_info_size + common_path_suffix_offset_unicode
        type: strz_unicode
        if: link_info_header_size >= 0x00000024

  link_info_flags:
    seq:
      - id: flags
        type: u4
    instances:
      volume_id_and_local_base_path:
        value: (flags & 0x00000001) != 0
      common_network_relative_link_and_path_suffix:
        value: (flags & 0x00000002) != 0

  volume_id:
    seq:
      - id: volume_id_size
        type: u4
        doc: "Size of the VolumeID structure."
      - id: drive_type
        type: u4
        doc: "Type of drive."
      - id: drive_serial_number
        type: u4
        doc: "Serial number of the drive."
      - id: volume_label_offset
        type: u4
        doc: "Location of the volume label."
      - id: volume_label_offset_unicode
        type: u4
        if: volume_label_offset == 0x00000014
        doc: "Location of the Unicode volume label."
      - id: remainder
        size: volume_id_size - (_io.pos - (_parent._io.pos - _parent.link_info_size + _parent.volume_id_offset))
    instances:
      volume_label:
        pos: (_parent._io.pos - _parent.link_info_size + _parent.volume_id_offset) + volume_label_offset
        type:
          switch-on: volume_label_offset == 0x00000014
          cases:
            true: strz_unicode
            false: strz_utf8
        doc: "Volume label."

  common_network_relative_link:
    seq:
      - id: common_network_relative_link_size
        type: u4
        doc: "Size of the CommonNetworkRelativeLink structure."
      - id: common_network_relative_link_flags
        type: common_network_relative_link_flags
      - id: net_name_offset
        type: u4
        doc: "Location of the NetName field."
      - id: device_name_offset
        type: u4
        doc: "Location of the DeviceName field."
      - id: network_provider_type
        type: u4
        doc: "Network provider type."
      - id: net_name_offset_unicode
        type: u4
        if: common_network_relative_link_size >= 0x00000014
        doc: "Location of the NetNameUnicode field."
      - id: device_name_offset_unicode
        type: u4
        if: common_network_relative_link_size >= 0x00000014
        doc: "Location of the DeviceNameUnicode field."
      - id: remainder
        size: common_network_relative_link_size - (_io.pos - (_parent._io.pos - _parent.link_info_size + _parent.common_network_relative_link_offset))
    instances:
      net_name:
        pos: (_parent._io.pos - _parent.link_info_size + _parent.common_network_relative_link_offset) + net_name_offset
        type: strz_utf8
      device_name:
        pos: (_parent._io.pos - _parent.link_info_size + _parent.common_network_relative_link_offset) + device_name_offset
        type: strz_utf8
        if: common_network_relative_link_flags.valid_device
      net_name_unicode:
        pos: (_parent._io.pos - _parent.link_info_size + _parent.common_network_relative_link_offset) + net_name_offset_unicode
        type: strz_unicode
        if: common_network_relative_link_size >= 0x00000014
      device_name_unicode:
        pos: (_parent._io.pos - _parent.link_info_size + _parent.common_network_relative_link_offset) + device_name_offset_unicode
        type: strz_unicode
        if: common_network_relative_link_flags.valid_device and common_network_relative_link_size >= 0x00000014

  common_network_relative_link_flags:
    seq:
      - id: flags
        type: u4
    instances:
      valid_device:
        value: (flags & 0x00000001) != 0
      valid_net_type:
        value: (flags & 0x00000002) != 0

  string_data:
    seq:
      - id: name_string
        type: string_data_item
        if: _root.header.link_flags.has_name
      - id: relative_path
        type: string_data_item
        if: _root.header.link_flags.has_relative_path
      - id: working_dir
        type: string_data_item
        if: _root.header.link_flags.has_working_dir
      - id: command_line_arguments
        type: string_data_item
        if: _root.header.link_flags.has_arguments
      - id: icon_location
        type: string_data_item
        if: _root.header.link_flags.has_icon_location

  string_data_item:
    seq:
      - id: count_characters
        type: u2
        doc: "Number of characters"
      - id: raw_string
        size: 'count_characters * (_root.header.link_flags.is_unicode ? 2 : 1)'
    instances:
      string:
        value: "_root.header.link_flags.is_unicode ? raw_string.to_s('UTF-16LE') : raw_string.to_s('UTF-8')"
        doc: "String data"
  extra_data:
    seq:
      - id: blocks
        type: extra_data_block
        repeat: until
        repeat-until: _.is_terminal_block
    instances:
      terminator_block_present:
        value: blocks[-1].is_terminal_block

  extra_data_block:
    seq:
      - id: size
        type: u4
        doc: "Size of the extra data block"
        if: _io.size - _io.pos >= 4  # Ensure at least 4 bytes are available to read the size
      - id: signature
        type: u4
        if: size > 0  # Read the signature only if the size is greater than 0
      - id: data
        size: size - 8
        if: size > 8  # Ensure that the size is large enough for the data block
    instances:
      is_terminal_block:
        value: size == 0x00000000

  # Helper types for string decoding
  strz_utf8:
    seq:
      - id: value
        type: str
        encoding: 'UTF-8'
        terminator: 0x00

  strz_unicode:
    seq:
      - id: value
        type: str
        encoding: 'UTF-16LE'
        terminator: 0000

enums:
  show_command_enum:
    1: sw_shownormal
    3: sw_showmaximized
    7: sw_showminnoactive

  virtual_key_codes:
    0: no_key
    48: key_0
    49: key_1
    50: key_2
    51: key_3
    52: key_4
    53: key_5
    54: key_6
    55: key_7
    56: key_8
    57: key_9
    65: key_a
    66: key_b
    67: key_c
    68: key_d
    69: key_e
    70: key_f
    71: key_g
    72: key_h
    73: key_i
    74: key_j
    75: key_k
    76: key_l
    77: key_m
    78: key_n
    79: key_o
    80: key_p
    81: key_q
    82: key_r
    83: key_s
    84: key_t
    85: key_u
    86: key_v
    87: key_w
    88: key_x
    89: key_y
    90: key_z
    112: key_f1
    113: key_f2
    114: key_f3
    115: key_f4
    116: key_f5
    117: key_f6
    118: key_f7
    119: key_f8
    120: key_f9
    121: key_f10
    122: key_f11
    123: key_f12
    124: key_f13
    125: key_f14
    126: key_f15
    127: key_f16
    128: key_f17
    129: key_f18
    130: key_f19
    131: key_f20
    132: key_f21
    133: key_f22
    134: key_f23
    135: key_f24
    144: num_lock
    145: scroll_lock

  hot_key_modifiers:
    0: no_modifiers
    1: shift
    2: ctrl
    4: alt
