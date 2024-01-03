// ignore_for_file: no-magic-number, unused_element, unused_field
// ignore_for_file: unused_local_variable, avoid-unused-parameters
// ignore_for_file: no-empty-block, constant_identifier_names

/// Virtual Key codes table
/// Symbolic constant name = decimal value 1..255
/// [Virtual-Key Codes](https://learn.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes)
enum VK {
  /// Left mouse button
  LBUTTON(1),

  /// Right mouse button
  RBUTTON(2),

  /// Control-break processing
  CANCEL(3),

  /// Middle mouse button (three-button mouse)
  MBUTTON(4),

  /// Windows 2000: X1 mouse button
  XBUTTON1(5),

  /// Windows 2000: X2 mouse button
  XBUTTON2(6),

  /// BACKSPACE key
  BACK(8),

  /// TAB key
  TAB(9),

  /// CLEAR key
  CLEAR(12),

  /// ENTER key
  RETURN(13),

  /// SHIFT key
  @Deprecated('Use LSHIFT instead')
  SHIFT(16, extendedKey: true),

  /// CTRL key
  @Deprecated('Use LCONTROL instead')
  CONTROL(17, extendedKey: true),

  /// ALT key
  @Deprecated('Use LMENU instead')
  MENU(18, extendedKey: true),

  /// PAUSE key
  PAUSE(19),

  /// CAPS LOCK key
  CAPITAL(20),

  /// IME Kana mode
  KANA(21),

  /// IME Hanguel mode (maintained for compatibility; use VK_HANGUL)
  HANGUEL(21),

  /// IME Hangul mode
  HANGUL(21),

  /// IME Junja mode
  JUNJA(23),

  /// IME final mode
  FINAL(24),

  /// IME Hanja mode
  HANJA(25),

  /// IME Kanji mode
  KANJI(25),

  /// ESC key
  ESCAPE(27),

  /// IME convert
  CONVERT(28),

  /// IME nonconvert
  NONCONVERT(29),

  /// IME accept
  ACCEPT(30),

  /// IME mode change request
  MODECHANGE(31),

  /// SPACEBAR
  SPACE(32),

  /// PAGE UP key
  PRIOR(33),

  /// PAGE DOWN key
  NEXT(34),

  /// END key
  END(35),

  /// HOME key
  HOME(36),

  /// LEFT ARROW key
  LEFT(37),

  /// UP ARROW key
  UP(38),

  /// RIGHT ARROW key
  RIGHT(39),

  /// DOWN ARROW key
  DOWN(40),

  /// SELECT key
  SELECT(41),

  /// PRINT key
  PRINT(42),

  /// EXECUTE key
  EXECUTE(43),

  /// PRINT SCREEN key
  SNAPSHOT(44),

  /// INS key
  INSERT(45),

  /// DEL key
  DELETE(46),

  /// HELP key
  HELP(47),

  /// 0 key
  KEY0(48),

  /// 1 key
  KEY1(49),

  /// 2 key
  KEY2(50),

  /// 3 key
  KEY3(51),

  /// 4 key
  KEY4(52),

  /// 5 key
  KEY5(53),

  /// 6 key
  KEY6(54),

  /// 7 key
  KEY7(55),

  /// 8 key
  KEY8(56),

  /// 9 key
  KEY9(57),

  /// A key
  A(65),

  /// B key
  B(66),

  /// C key
  C(67),

  /// D key
  D(68),

  /// E key
  E(69),

  /// F key
  F(70),

  /// G key
  G(71),

  /// H key
  H(72),

  /// I key
  I(73),

  /// J key
  J(74),

  /// K key
  K(75),

  /// L key
  L(76),

  /// M key
  M(77),

  /// N key
  N(78),

  /// O key
  O(79),

  /// P key
  P(80),

  /// Q key
  Q(81),

  /// R key
  R(82),

  /// S key
  S(83),

  /// T key
  T(84),

  /// U key
  U(85),

  /// V key
  V(86),

  /// W key
  W(87),

  /// X key
  X(88),

  /// Y key
  Y(89),

  /// Z key
  Z(90),

  /// Left Windows key (Microsoft® Natural® keyboard)
  LWIN(91),

  /// Right Windows key (Natural keyboard)
  RWIN(92),

  /// Applications key (Natural keyboard)
  APPS(93),

  /// Computer Sleep key
  SLEEP(95),

  /// Numeric keypad 0 key
  NUMPAD0(96),

  /// Numeric keypad 1 key
  NUMPAD1(97),

  /// Numeric keypad 2 key
  NUMPAD2(98),

  /// Numeric keypad 3 key
  NUMPAD3(99),

  /// Numeric keypad 4 key
  NUMPAD4(100),

  /// Numeric keypad 5 key
  NUMPAD5(101),

  /// Numeric keypad 6 key
  NUMPAD6(102),

  /// Numeric keypad 7 key
  NUMPAD7(103),

  /// Numeric keypad 8 key
  NUMPAD8(104),

  /// Numeric keypad 9 key
  NUMPAD9(105),

  /// Multiply key
  MULTIPLY(106),

  /// Add key
  ADD(107),

  /// Separator key
  SEPARATOR(108),

  /// Subtract key
  SUBTRACT(109),

  /// Decimal key
  DECIMAL(110),

  /// Divide key
  DIVIDE(111),

  /// F1 key
  F1(112),

  /// F2 key
  F2(113),

  /// F3 key
  F3(114),

  /// F4 key
  F4(115),

  /// F5 key
  F5(116),

  /// F6 key
  F6(117),

  /// F7 key
  F7(118),

  /// F8 key
  F8(119),

  /// F9 key
  F9(120),

  /// F10 key
  F10(121),

  /// F11 key
  F11(122),

  /// F12 key
  F12(123),

  /// F13 key
  F13(124),

  /// F14 key
  F14(125),

  /// F15 key
  F15(126),

  /// F16 key
  F16(127),

  /// F17 key
  F17(128),

  /// F18 key
  F18(129),

  /// F19 key
  F19(130),

  /// F20 key
  F20(131),

  /// F21 key
  F21(132),

  /// F22 key
  F22(133),

  /// F23 key
  F23(134),

  /// F24 key
  F24(135),

  /// NUM LOCK key
  NUMLOCK(144),

  /// SCROLL LOCK key
  SCROLL(145),

  /// Left SHIFT key
  LSHIFT(160),

  /// Right SHIFT key
  RSHIFT(161),

  /// Left CONTROL key
  LCONTROL(162),

  /// Right CONTROL key
  RCONTROL(163),

  /// Left MENU key
  LMENU(164),

  /// Right MENU key
  RMENU(165),

  /// Windows 2000: Browser Back key
  BROWSER_BACK(166),

  /// Windows 2000: Browser Forward key
  BROWSER_FORWARD(167),

  /// Windows 2000: Browser Refresh key
  BROWSER_REFRESH(168),

  /// Windows 2000: Browser Stop key
  BROWSER_STOP(169),

  /// Windows 2000: Browser Search key
  BROWSER_SEARCH(170),

  /// Windows 2000: Browser Favorites key
  BROWSER_FAVORITES(171),

  /// Windows 2000: Browser Start and Home key
  BROWSER_HOME(172),

  /// Windows 2000: Volume Mute key
  VOLUME_MUTE(173),

  /// Windows 2000: Volume Down key
  VOLUME_DOWN(174),

  /// Windows 2000: Volume Up key
  VOLUME_UP(175),

  /// Windows 2000: Next Track key
  MEDIA_NEXT_TRACK(176),

  /// Windows 2000: Previous Track key
  MEDIA_PREV_TRACK(177),

  /// Windows 2000: Stop Media key
  MEDIA_STOP(178),

  /// Windows 2000: Play/Pause Media key
  MEDIA_PLAY_PAUSE(179),

  /// Windows 2000: Start Mail key
  LAUNCH_MAIL(180),

  /// Windows 2000: Select Media key
  LAUNCH_MEDIA_SELECT(181),

  /// Windows 2000: Start Application 1 key
  LAUNCH_APP1(182),

  /// Windows 2000: Start Application 2 key
  LAUNCH_APP2(183),

  /// Windows 2000: For the US standard keyboard, the ';:' key
  OEM_1(186),

  /// Windows 2000: For any country/region, the '+' key
  OEM_PLUS(187),

  /// Windows 2000: For any country/region, the ',' key
  OEM_COMMA(188),

  /// Windows 2000: For any country/region, the '-' key
  OEM_MINUS(189),

  /// Windows 2000: For any country/region, the '.' key
  OEM_PERIOD(190),

  /// Windows 2000: For the US standard keyboard, the '/?' key
  OEM_2(191),

  /// Windows 2000: For the US standard keyboard, the '`~' key
  OEM_3(192),

  /// Windows 2000: For the US standard keyboard, the '[{' key
  OEM_4(219),

  /// Windows 2000: For the US standard keyboard, the '\|' key
  OEM_5(220),

  /// Windows 2000: For the US standard keyboard, the ']}' key
  OEM_6(221),

  /// Windows 2000: For the US standard keyboard,
  /// the 'single-quote/double-quote' key
  OEM_7(222),

  /// Windows 2000: Used for miscellaneous characters,
  /// it can vary by keyboard.
  OEM_8(223),

  /// Windows 2000: Either the angle bracket key
  /// or the backslash key on the RT 102-key keyboard
  OEM_102(226),

  /// Windows 95/98, Windows NT 4.0, Windows 2000: IME PROCESS key
  PROCESSKEY(229),

  /// Windows 2000: Used to pass Unicode characters
  /// as if they were keystrokes. The VK_PACKET key is
  /// the low word of a 32-bit Virtual Key value used
  /// for non-keyboard input methods. For more information,
  /// see Remark in KEYBDINPUT, SendInput, WM_KEYDOWN, and WM_KEYUP
  PACKET(231),

  /// Attn key
  ATTN(246),

  /// CrSel key
  CRSEL(247),

  /// ExSel key
  EXSEL(248),

  /// Erase EOF key
  EREOF(249),

  /// Play key
  PLAY(250),

  /// Zoom key
  ZOOM(251),

  /// Reserved for future use
  NONAME(252),

  /// PA1 key
  PA1(253),

  /// Clear key
  OEM_CLEAR(254);

  /// Virtual key code.
  const VK(this.code, {this.extendedKey = false});

  /// Returns the virtual key for the given [code].
  factory VK.fromCode(int code) => _map[code] ?? (throw ArgumentError('Invalid code: $code'));

  /// The map of virtual keys.
  static final Map<int, VK> _map = <int, VK>{
    for (final vk in VK.values) vk.code: vk,
  };

  /// The virtual key code.
  final int code;

  /// Whether the key is extended.
  final bool extendedKey;

  /// The name of the virtual key.
  String get hex => '0x${code.toRadixString(16).padLeft(2, '0')}';
}
