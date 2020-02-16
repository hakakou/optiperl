Unit PacketHeader;

Interface

Uses
  windows, winsock;

Const
  TCPFlag_URG = 0;
  TCPFlag_ACK = 2;
  TCPFlag_PSH = 4;
  TCPFlag_RST = 8;
  TCPFlag_SYN = 16;
  TCPFlag_FYN = 32;

  IPPROTO_IP = 0; //dummy for IP
  IPPROTO_ICMP = 1; // control message protocol
  IPPROTO_IGMP = 2; //internet group management protocol
  IPPROTO_GGP = 3; //  gateway^2 (deprecated)
  IPPROTO_TCP = 6; //   tcp
  IPPROTO_PUP = 12; //  pup
  IPPROTO_UDP = 17; //  user datagram protocol
  IPPROTO_IDP = 22; //  xns idp
  IPPROTO_ND = 77; //  UNOFFICIAL net disk proto

  IPPROTO_RAW = 255; // raw IP packet
  IPPROTO_MAX = 256;

  SIO_RCVALL = $98000001;

Type

  TIPPROTO = Record
    itype: word;
    name: String;
  End;

  PIP_Header = ^TIP_Header;
  TIP_Header = Packed Record
    ip_verlen: Byte;
    ip_tos: Byte;
    ip_totallength: Word;
    ip_id: Word;
    ip_offset: Word;
    ip_ttl: Byte;
    ip_protocol: Byte;
    ip_checksum: Word;
    ip_srcaddr: LongWord;
    ip_destaddr: LongWord;
    data:array [0..0] of char;
  End;
  PUDP_Header = ^TUDP_Header;
  TUDP_Header = Packed Record
    src_portno: Word;
    dst_portno: Word;
    udp_length: Word;
    udp_checksum: Word;
  End;
  PTCP_Header = ^TTCP_Header;
  TTCP_Header = Packed Record
    src_portno: Word;
    dst_portno: Word;
    Sequenceno: LongWord;
    Acknowledgeno: LongWord;
    DataOffset: Byte;
    flag: byte;
    Windows: WORD;
    checksum: WORD;
    UrgentPointer: WORD;
  End;

Const
  IPPROTO: Array[0..8] Of TIPPROTO = (
    (iType: IPPROTO_IP; name: 'IP'),
    (iType: IPPROTO_ICMP; name: 'ICMP'),
    (iType: IPPROTO_IGMP; name: 'IGMP'),
    (iType: IPPROTO_GGP; name: 'GGP'),
    (iType: IPPROTO_TCP; name: 'TCP'),
    (iType: IPPROTO_PUP; name: 'PUP'),
    (iType: IPPROTO_UDP; name: 'UDP'),
    (iType: IPPROTO_IDP; name: 'IDP'),
    (iType: IPPROTO_ND; name: 'ND'));

Implementation

End.

