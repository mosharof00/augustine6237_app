import 'package:flutter/material.dart';

/// Single Source of Truth for all Colors across the BetSocial Mobile App.
/// Updating any color token here automatically updates all screens and modules.
class AppColor {
  AppColor._();

  // ── Brand / Core Betting Actions ─────────────────────
  /// Primary action / "Back" bet / "Yes" choice (Sky Blue)
  static const Color primary = Color(0xFF0EA5E9);
  static const Color actionBack = Color(0xFF0EA5E9);
  static const Color actionBackHover = Color(0xFF0284C7);

  /// Secondary action / "Oppose" bet / "No" choice (Coral Rose)
  static const Color actionOppose = Color(0xFFF43F5E);
  static const Color actionOpposeHover = Color(0xFFE11D48);

  static const Color secondary = Color(0xFF6366F1); // Electric Indigo accent
  static const Color primaryDisable = Color(0xFF475569);

  // ── Surfaces & Backgrounds (Dark-First Theme) ─────────
  /// Main application background (Deep Midnight Navy)
  static const Color background = Color(0xFF0B1222);
  static const Color darkBackground = Color(0xFF0B1222);
  static const Color darkBackground2 = Color(0xFF0F172A);

  /// Elevated card & module surface
  static const Color surface = Color(0xFF162032);
  static const Color darkSurface = Color(0xFF162032);

  /// Input fields, chips, inner borders
  static const Color surfaceSubtle = Color(0xFF1E293B);
  static const Color borderSubtle = Color(0xFF233044);
  static const Color borderFocus = Color(0xFF38BDF8);

  // ── Text & Typography ─────────────────────────────────
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textDim = Color(0xFF64748B);
  static const Color white = Color(0xFFFFFFFF);
  static const Color hintText = Color(0xFF64748B);

  // ── Status & Results ──────────────────────────────────
  static const Color statusSuccess = Color(0xFF10B981); // Bet Won / Deposit Confirmed
  static const Color statusPending = Color(0xFFF59E0B); // Escrow Locked / In Review
  static const Color statusFailed = Color(0xFFEF4444);  // Bet Lost / Cancelled
  static const Color error = Color(0xFFEF4444);
  static const Color amber = Color(0xFFFFBF00); // Star ratings / warnings

  // ── Legacy Compatibility Aliases ─────────────────────
  static const Color grey410 = Color(0xFF64748B);
}
