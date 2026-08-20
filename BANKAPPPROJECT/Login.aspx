<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="BANKAPPPROJECT.Login" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Sign In — Aurelia Private</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,300;9..144,400;9..144,500&family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet" />
    <style>
        :root {
            --bg:              #0c1713;
            --surface:         #121e1a;
            --surface-2:       #1a2722;
            --text:            #f1ead8;
            --muted:           #8a9590;
            --primary:         #27b487;
            --champagne:       #d4b06a;
            --champagne-soft:  #e4c896;
            --ink:             #07100d;
            --border:          rgba(241,234,216,0.08);
            --border-strong:   rgba(241,234,216,0.16);
            --danger:          #e56b7a;
            --radius:          18px;
            --radius-sm:       10px;
            --shadow-sm:       0 2px 8px rgba(0,0,0,0.35);
            --shadow:          0 30px 60px -20px rgba(0,0,0,0.7), 0 8px 20px -8px rgba(0,0,0,0.5);
            --shadow-glow:     0 0 60px -10px rgba(39,180,135,0.35);
            --gradient-noir:   linear-gradient(135deg, #07100d 0%, #122019 100%);
            --gradient-em:     linear-gradient(135deg, #0f2a22 0%, #1d4a3b 100%);
            --gradient-gold:   linear-gradient(135deg, #e4c896 0%, #b08a3f 100%);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        html, body {
            min-height: 100vh;
            background: var(--bg);
            color: var(--text);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 24px;
            -webkit-font-smoothing: antialiased;
            line-height: 1.55;
            font-feature-settings: "ss01", "cv11";
        }

        /* grain */
        body::before {
            content: "";
            position: fixed; inset: 0;
            background-image: radial-gradient(rgba(241,234,216,0.04) 1px, transparent 1px);
            background-size: 3px 3px;
            pointer-events: none;
            z-index: 0;
        }

        /* ambient glow */
        body::after {
            content: "";
            position: fixed;
            top: 20%; left: 50%;
            transform: translate(-50%, -50%);
            width: 600px; height: 600px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(39,180,135,0.06) 0%, transparent 65%);
            pointer-events: none;
            z-index: 0;
        }

        .login-wrap {
            width: 100%;
            max-width: 440px;
            position: relative;
            z-index: 1;
        }

        /* ─── BRAND ─── */
        .brand {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 14px;
            margin-bottom: 36px;
            color: var(--text);
            text-decoration: none;
        }

        .brand-mark {
            width: 42px; height: 42px;
            border-radius: 999px;
            background: var(--gradient-gold);
            display: grid; place-items: center;
            color: var(--ink);
            font-family: 'Fraunces', serif;
            font-weight: 500;
            font-size: 20px;
            box-shadow: 0 4px 18px rgba(212,176,106,0.28);
        }

        .brand-text {
            display: flex;
            flex-direction: column;
            line-height: 1;
            font-family: 'Fraunces', serif;
            font-size: 22px;
            font-weight: 400;
            letter-spacing: 0.015em;
        }

        .brand-text small {
            font-family: 'Inter', sans-serif;
            font-size: 8.5px;
            text-transform: uppercase;
            letter-spacing: 0.32em;
            color: var(--muted);
            margin-top: 5px;
            font-weight: 600;
        }

        /* ─── CARD ─── */
        .card {
            background: var(--surface);
            border: 1px solid var(--border-strong);
            border-radius: var(--radius);
            padding: 40px;
            box-shadow: var(--shadow);
            position: relative;
            overflow: hidden;
        }

        /* subtle top shimmer */
        .card::before {
            content: "";
            position: absolute;
            top: 0; left: 10%; right: 10%; height: 1px;
            background: linear-gradient(90deg, transparent, rgba(212,176,106,0.3), transparent);
        }

        .card-heading {
            font-family: 'Fraunces', serif;
            font-size: 30px;
            font-weight: 300;
            color: var(--text);
            margin-bottom: 6px;
            letter-spacing: -0.015em;
            line-height: 1.1;
        }

        .card-subtitle {
            font-size: 13px;
            color: var(--muted);
            margin-bottom: 30px;
            letter-spacing: 0.01em;
        }

        /* ─── FORM ─── */
        label {
            display: block;
            margin: 20px 0 7px;
            font-size: 9.5px;
            font-weight: 700;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.24em;
        }

        label:first-of-type { margin-top: 0; }

        input {
            width: 100%;
            padding: 13px 16px;
            border: 1px solid var(--border-strong);
            border-radius: var(--radius-sm);
            font-size: 14px;
            font-family: 'Inter', sans-serif;
            color: var(--text);
            background: var(--bg);
            outline: none;
            transition: border-color .2s ease, box-shadow .2s ease, background .2s ease;
        }

        input::placeholder { color: var(--muted); opacity: 0.6; }

        input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(39,180,135,0.12);
            background: var(--surface-2);
        }

        /* password reveal icon area */
        .input-wrap { position: relative; }
        .input-wrap input { padding-right: 44px; }

        /* ─── BUTTON ─── */
        .btn {
            width: 100%;
            padding: 14px 28px;
            background: var(--gradient-em);
            color: var(--text) !important;
            border: 1px solid var(--border-strong);
            border-radius: var(--radius-sm);
            font-size: 11.5px;
            font-weight: 600;
            letter-spacing: 0.14em;
            text-transform: uppercase;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            margin-top: 28px;
            transition: all .25s cubic-bezier(0.22,1,0.36,1);
            position: relative;
            overflow: hidden;
        }

        .btn::after {
            content: "";
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(39,180,135,0.15) 0%, transparent 60%);
            opacity: 0;
            transition: opacity .2s ease;
        }

        .btn:hover {
            border-color: var(--primary);
            box-shadow: var(--shadow-glow);
            transform: translateY(-1px);
        }
        .btn:hover::after { opacity: 1; }
        .btn:active { transform: translateY(0); }

        /* ─── MESSAGES ─── */
        .msg {
            padding: 13px 16px;
            border-radius: var(--radius-sm);
            margin-top: 16px;
            font-size: 13px;
            font-weight: 500;
            border: 1px solid;
        }
        .msg-error {
            background: rgba(229,107,122,0.07);
            color: var(--danger);
            border-color: rgba(229,107,122,0.28);
        }
        .msg-ok {
            background: rgba(39,180,135,0.07);
            color: var(--primary);
            border-color: rgba(39,180,135,0.28);
        }

        /* legacy .msg class from Login.aspx.cs */
        .msg div.msg {
            padding: 0; border: none; background: none; margin: 0;
            color: var(--danger);
        }

        /* ─── DIVIDER ─── */
        .divider {
            border: none;
            border-top: 1px solid var(--border);
            margin: 28px 0 0;
        }

        /* ─── FOOTER LINK ─── */
        .footer-link {
            text-align: center;
            margin-top: 22px;
            font-size: 13px;
            color: var(--muted);
        }

        .footer-link a {
            color: var(--champagne);
            font-weight: 600;
            transition: color .15s ease;
        }
        .footer-link a:hover { color: var(--champagne-soft); }

        /* ─── SECURITY BADGE ─── */
        .secure-badge {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            margin-top: 24px;
            font-size: 10px;
            color: var(--muted);
            font-family: 'JetBrains Mono', monospace;
            letter-spacing: 0.08em;
            opacity: 0.6;
        }

        @media (max-width: 480px) {
            .card { padding: 28px 24px; }
            .card-heading { font-size: 26px; }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
<div class="login-wrap">

    <!-- Brand -->
    <a href="Login.aspx" class="brand">
        <span class="brand-mark">A</span>
        <span class="brand-text">
            Aurelia
            <small>Private Banking</small>
        </span>
    </a>

    <!-- Card -->
    <div class="card">
        <h2 class="card-heading">Welcome back</h2>
        <p class="card-subtitle">Sign in to your account to continue.</p>

        <label>Username</label>
        <asp:TextBox ID="txtUsername" runat="server" placeholder="Your username" />

        <label>Password</label>
        <div class="input-wrap">
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Your password" />
        </div>

        <asp:Button ID="btnLogin" runat="server" Text="Sign In" CssClass="btn" OnClick="btnLogin_Click" />
        <asp:Label ID="lblMsg" runat="server" />

        <hr class="divider" />
        <div class="footer-link">
            No account?&nbsp;<a href="Register.aspx">Register here</a>
        </div>
    </div>

    <!-- Security note -->
    <div class="secure-badge">
        <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>
        </svg>
        Secured with 256-bit encryption
    </div>

</div>
</form>
</body>
</html>
