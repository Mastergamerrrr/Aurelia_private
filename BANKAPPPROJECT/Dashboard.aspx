<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="Dashboard.aspx.cs" Inherits="BANKAPPPROJECT.Dashboard" %>

<asp:Content ID="c1" ContentPlaceHolderID="MainContent" runat="server">

<h2 style="display:none;">Dashboard</h2>

<style>
    /* ─── DASHBOARD PAGE ─── */

    .dash-welcome {
        margin-bottom: 24px;
    }
    .dash-welcome h2 {
        display: block !important;
        font-family: 'Fraunces', serif;
        font-size: 30px;
        font-weight: 300;
        color: var(--text);
        margin: 0 0 4px;
        letter-spacing: -0.01em;
    }
    .dash-welcome p {
        font-size: 13px;
        color: var(--muted);
        letter-spacing: 0.02em;
    }

    /* ─── TOP GRID ─── */
    .dash-top {
        display: grid;
        grid-template-columns: 1fr 260px;
        gap: 16px;
        margin-bottom: 20px;
    }

    /* ─── BALANCE HERO CARD ─── */
    .balance-card {
        background: linear-gradient(135deg, #0b2218 0%, #0e2e21 40%, #143d2c 100%);
        border: 1px solid rgba(39,180,135,0.2);
        border-radius: 20px;
        padding: 32px 36px;
        position: relative;
        overflow: hidden;
        box-shadow: 0 20px 60px -10px rgba(0,0,0,0.6), inset 0 1px 0 rgba(39,180,135,0.1);
    }

    /* decorative circle */
    .balance-card::before {
        content: "";
        position: absolute;
        right: -60px; top: -60px;
        width: 260px; height: 260px;
        border-radius: 50%;
        background: radial-gradient(circle, rgba(39,180,135,0.12) 0%, transparent 70%);
        pointer-events: none;
    }
    .balance-card::after {
        content: "";
        position: absolute;
        left: -40px; bottom: -40px;
        width: 200px; height: 200px;
        border-radius: 50%;
        background: radial-gradient(circle, rgba(212,176,106,0.07) 0%, transparent 70%);
        pointer-events: none;
    }

    .balance-card-top {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 8px;
    }

    .balance-card-label {
        font-size: 9px;
        font-weight: 700;
        letter-spacing: 0.25em;
        text-transform: uppercase;
        color: rgba(39,180,135,0.8);
    }

    .acct-badge {
        font-family: 'JetBrains Mono', monospace;
        font-size: 11px;
        color: rgba(241,234,216,0.5);
        letter-spacing: 0.08em;
        background: rgba(241,234,216,0.05);
        padding: 5px 10px;
        border-radius: 999px;
        border: 1px solid rgba(241,234,216,0.1);
    }
    .acct-badge span {
        color: rgba(241,234,216,0.8);
        font-weight: 600;
    }

    .balance-amount {
        font-family: 'Fraunces', serif;
        font-size: 52px;
        font-weight: 300;
        color: var(--text);
        letter-spacing: -0.04em;
        line-height: 1;
        margin: 12px 0 28px;
        position: relative;
    }
    .balance-amount::after {
        content: "";
        display: block;
        width: 48px; height: 1px;
        background: var(--gradient-gold);
        margin-top: 18px;
    }

    .balance-details-row {
        display: flex;
        gap: 36px;
        flex-wrap: wrap;
    }

    .balance-detail {
        display: flex;
        flex-direction: column;
        gap: 4px;
    }
    .bd-label {
        font-size: 8.5px;
        font-weight: 700;
        letter-spacing: 0.2em;
        text-transform: uppercase;
        color: rgba(241,234,216,0.35);
    }
    .bd-value {
        font-size: 13px;
        font-weight: 600;
        color: rgba(241,234,216,0.9);
        font-family: 'JetBrains Mono', monospace;
        letter-spacing: 0.02em;
    }
    .bd-value.sent-val {
        color: #e4a84e;
    }

    /* ─── THIS MONTH SIDE ─── */
    .this-month-card {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 20px;
        padding: 24px;
        display: flex;
        flex-direction: column;
        gap: 12px;
        box-shadow: var(--shadow-sm);
    }

    .tm-header {
        font-size: 9px;
        font-weight: 700;
        letter-spacing: 0.25em;
        text-transform: uppercase;
        color: var(--muted);
        margin-bottom: 4px;
    }

    .tm-stat {
        background: var(--surface-2);
        border: 1px solid var(--border);
        border-radius: var(--radius-sm);
        padding: 14px 16px;
        display: flex;
        align-items: center;
        gap: 12px;
    }
    .tm-icon {
        width: 32px; height: 32px;
        border-radius: 8px;
        display: grid; place-items: center;
        flex-shrink: 0;
    }
    .tm-icon.green { background: rgba(39,180,135,0.12); color: var(--primary); }
    .tm-icon.red   { background: rgba(229,107,122,0.12); color: var(--danger); }
    .tm-stat-body { flex: 1; min-width: 0; }
    .tm-stat-label { font-size: 10px; color: var(--muted); font-weight: 500; margin-bottom: 3px; }
    .tm-stat-value {
        font-family: 'Fraunces', serif;
        font-size: 17px;
        font-weight: 300;
        color: var(--text);
        letter-spacing: -0.02em;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .tm-stat-badge {
        font-size: 10px;
        font-weight: 600;
        padding: 2px 7px;
        border-radius: 999px;
        white-space: nowrap;
        flex-shrink: 0;
    }
    .tm-stat-badge.up   { background: rgba(39,180,135,0.12); color: var(--primary); }
    .tm-stat-badge.down { background: rgba(229,107,122,0.12); color: var(--danger); }

    /* ─── QUICK ACTIONS ─── */
    .quick-actions {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 14px;
        margin-bottom: 24px;
    }

    .action-card {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: var(--radius);
        padding: 22px 18px;
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        gap: 12px;
        transition: all .22s cubic-bezier(0.22,1,0.36,1);
        cursor: pointer;
        color: var(--text) !important;
        text-decoration: none !important;
    }
    .action-card:hover {
        border-color: var(--primary);
        box-shadow: 0 8px 32px -8px rgba(39,180,135,0.2);
        transform: translateY(-2px);
        background: var(--surface-2);
    }
    .action-card:hover .action-icon { background: rgba(39,180,135,0.15); color: var(--primary); }

    .action-icon {
        width: 40px; height: 40px;
        border-radius: 10px;
        background: rgba(241,234,216,0.06);
        display: grid; place-items: center;
        color: var(--muted);
        transition: all .2s ease;
    }
    .action-card:hover .action-icon { color: var(--primary); }
    .action-icon svg { width: 18px; height: 18px; }

    .action-title {
        font-size: 13px;
        font-weight: 600;
        color: var(--text);
        line-height: 1.2;
    }
    .action-sub {
        font-size: 11px;
        color: var(--muted);
        font-weight: 400;
    }

    /* ─── NOTIFICATIONS ─── */
    .notif-section { margin-bottom: 24px; }
    .section-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 14px;
    }
    .section-title {
        font-size: 12px;
        font-weight: 700;
        letter-spacing: 0.2em;
        text-transform: uppercase;
        color: var(--muted);
    }
    .view-all-link {
        font-size: 11px;
        font-weight: 600;
        color: var(--champagne);
        letter-spacing: 0.05em;
        transition: color .15s ease;
    }
    .view-all-link:hover { color: var(--champagne-soft); }

    .notif-item {
        display: flex;
        align-items: center;
        gap: 14px;
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: var(--radius-sm);
        padding: 14px 18px;
        margin-bottom: 8px;
        transition: border-color .15s ease;
    }
    .notif-item:hover { border-color: var(--border-strong); }
    .notif-avatar {
        width: 36px; height: 36px;
        border-radius: 999px;
        background: var(--gradient-em);
        border: 1px solid rgba(39,180,135,0.25);
        display: grid; place-items: center;
        font-size: 11px;
        font-weight: 700;
        color: var(--primary);
        flex-shrink: 0;
        font-family: 'JetBrains Mono', monospace;
    }
    .notif-body { flex: 1; }
    .notif-name { font-size: 13px; font-weight: 600; color: var(--text); margin-bottom: 2px; }
    .notif-date { font-size: 11px; color: var(--muted); }
    .notif-amount {
        font-family: 'Fraunces', serif;
        font-size: 18px;
        font-weight: 300;
        color: var(--primary);
        letter-spacing: -0.01em;
    }

    /* ─── TRANSACTIONS ─── */
    .txn-section { }
    .txn-grid-wrap {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: var(--radius);
        overflow: hidden;
        box-shadow: var(--shadow-sm);
    }
    .txn-grid-wrap table { margin: 0; }
    .txn-grid-wrap table th {
        background: var(--surface-2);
        padding: 14px 18px;
    }
    .txn-grid-wrap table td { padding: 14px 18px; }

    /* GridView overrides */
    .txn-grid-wrap .grid th {
        background: var(--surface-2) !important;
        color: var(--muted) !important;
        font-size: 9px !important;
        font-weight: 700 !important;
        letter-spacing: 0.2em !important;
        text-transform: uppercase !important;
        padding: 14px 18px !important;
        border-bottom: 1px solid var(--border-strong) !important;
    }
    .txn-grid-wrap .grid td {
        padding: 14px 18px !important;
        border-bottom: 1px solid var(--border) !important;
        color: var(--text) !important;
        font-family: 'JetBrains Mono', monospace !important;
        font-size: 12px !important;
    }
    .txn-grid-wrap .grid tr:last-child td { border-bottom: none !important; }
    .txn-grid-wrap .grid tr:hover td { background: rgba(212,176,106,0.03) !important; }

    /* ─── RESPONSIVE ─── */
    @media (max-width: 1000px) {
        .dash-top { grid-template-columns: 1fr; }
        .this-month-card { flex-direction: row; flex-wrap: wrap; }
        .this-month-card .tm-stat { flex: 1; min-width: 180px; }
    }
    @media (max-width: 700px) {
        .quick-actions { grid-template-columns: repeat(2, 1fr); }
        .balance-amount { font-size: 38px; }
        .balance-details-row { gap: 18px; }
    }
    @media (max-width: 480px) {
        .quick-actions { grid-template-columns: 1fr; }
    }
</style>

<!-- Welcome -->
<div class="dash-welcome">
    <h2>Dashboard</h2>
    <p>Your financial overview at a glance.</p>
</div>

<!-- Top Grid: Balance Card + This Month -->
<div class="dash-top">

    <!-- Balance Hero Card -->
    <div class="balance-card">
        <div class="balance-card-top">
            <span class="balance-card-label">Total Current Balance</span>
            <span class="acct-badge">
                Account No.&nbsp;<span><asp:Label ID="lblAcct" runat="server" /></span>
            </span>
        </div>

        <div class="balance-amount">
            <asp:Label ID="lblBal" runat="server" />
        </div>

        <div class="balance-details-row">
            <div class="balance-detail">
                <span class="bd-label">Full Name</span>
                <span class="bd-value"><asp:Label ID="lblName" runat="server" /></span>
            </div>
            <div class="balance-detail">
                <span class="bd-label">Date Registered</span>
                <span class="bd-value"><asp:Label ID="lblDate" runat="server" /></span>
            </div>
            <div class="balance-detail">
                <span class="bd-label">Total Sent</span>
                <span class="bd-value sent-val"><asp:Label ID="lblSent" runat="server" /></span>
            </div>
        </div>

        <!-- Hidden duplicates required by code-behind -->
        <span style="display:none;"><asp:Label ID="lblAcct2" runat="server" /></span>
        <span style="display:none;"><asp:Label ID="lblBal2" runat="server" /></span>
        <span style="display:none;"><asp:Label ID="lblSent2" runat="server" /></span>
    </div>

    <!-- This Month (live data) -->
    <div class="this-month-card">
        <p class="tm-header">This Month</p>

        <%-- Hidden direction labels read by JS to set badge classes --%>
        <asp:Label ID="lblInDir"  runat="server" style="display:none;" />
        <asp:Label ID="lblOutDir" runat="server" style="display:none;" />

        <div class="tm-stat">
            <div class="tm-icon green">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/>
                    <polyline points="17 6 23 6 23 12"/>
                </svg>
            </div>
            <div class="tm-stat-body">
                <div class="tm-stat-label">Money In</div>
                <div class="tm-stat-value"><asp:Label ID="lblMoneyIn" runat="server" /></div>
            </div>
            <span class="tm-stat-badge" id="badgeIn"><asp:Label ID="lblInPct" runat="server" /></span>
        </div>

        <div class="tm-stat">
            <div class="tm-icon red">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="23 18 13.5 8.5 8.5 13.5 1 6"/>
                    <polyline points="17 18 23 18 23 12"/>
                </svg>
            </div>
            <div class="tm-stat-body">
                <div class="tm-stat-label">Money Out</div>
                <div class="tm-stat-value"><asp:Label ID="lblMoneyOut" runat="server" /></div>
            </div>
            <span class="tm-stat-badge" id="badgeOut"><asp:Label ID="lblOutPct" runat="server" /></span>
        </div>
    </div>

    <script>
        (function () {
            var inDir  = document.getElementById('<%= lblInDir.ClientID %>');
            var outDir = document.getElementById('<%= lblOutDir.ClientID %>');
            var bIn    = document.getElementById('badgeIn');
            var bOut   = document.getElementById('badgeOut');
            if (inDir  && bIn)  bIn.classList.add(inDir.textContent.trim()  || 'up');
            if (outDir && bOut) bOut.classList.add(outDir.textContent.trim() || 'down');
        })();
    </script>
</div>

<!-- Quick Actions -->
<div class="quick-actions">
    <a href="Deposit.aspx" class="action-card">
        <div class="action-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                <circle cx="12" cy="12" r="9"/><path d="M12 8v8m-4-4 4 4 4-4"/>
            </svg>
        </div>
        <div>
            <div class="action-title">Deposit</div>
            <div class="action-sub">Tap to deposit</div>
        </div>
    </a>
    <a href="Withdraw.aspx" class="action-card">
        <div class="action-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                <circle cx="12" cy="12" r="9"/><path d="M12 16V8m-4 4 4-4 4 4"/>
            </svg>
        </div>
        <div>
            <div class="action-title">Withdraw</div>
            <div class="action-sub">Tap to withdraw</div>
        </div>
    </a>
    <a href="SendMoney.aspx" class="action-card">
        <div class="action-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                <path d="M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z"/>
            </svg>
        </div>
        <div>
            <div class="action-title">Send Money</div>
            <div class="action-sub">Tap to send money</div>
        </div>
    </a>
    <a href="StatementOfAccount.aspx" class="action-card">
        <div class="action-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                <polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/>
                <line x1="16" y1="17" x2="8" y2="17"/>
            </svg>
        </div>
        <div>
            <div class="action-title">View Reports</div>
            <div class="action-sub">Tap to view reports</div>
        </div>
    </a>
</div>

<!-- Notifications -->
<asp:Panel ID="pnlNotif" runat="server" Visible="false">
    <div class="notif-section">
        <div class="section-header">
            <span class="section-title">Recently Received &mdash; CloudMoney sent your way</span>
            <a href="MySentReceived.aspx" class="view-all-link">View all</a>
        </div>
        <asp:Repeater ID="rptNotif" runat="server">
            <ItemTemplate>
                <div class="notif-item">
                    <div class="notif-avatar"><%# Eval("SenderAcctNo").ToString().Substring(0,2) %></div>
                    <div class="notif-body">
                        <div class="notif-name">Account No. <%# Eval("SenderAcctNo") %></div>
                        <div class="notif-date"><%# Eval("SendDate", "{0:MMM dd, yyyy · hh:mm tt}") %></div>
                    </div>
                    <div class="notif-amount">+PHP <%# Eval("Amount", "{0:N2}") %></div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Panel>

<!-- Recent Transactions -->
<div class="txn-section">
    <div class="section-header">
        <span class="section-title">Recent Transactions</span>
    </div>
    <div class="txn-grid-wrap">
        <asp:GridView ID="gvTxn" runat="server" AutoGenerateColumns="true"
            CssClass="grid" GridLines="None" />
    </div>
</div>

</asp:Content>
