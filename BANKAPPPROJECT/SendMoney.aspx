<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="SendMoney.aspx.cs" Inherits="BANKAPPPROJECT.SendMoney" %>

<asp:Content ID="c1" ContentPlaceHolderID="MainContent" runat="server">

<h2>Send CloudMoney</h2>

<style>
    /* ─── SEND MONEY PAGE ─── */

    .send-layout {
        max-width: 680px;
    }

    /* ─── STEP 1: Find Recipient ─── */
    .find-row {
        display: flex;
        gap: 10px;
        align-items: flex-end;
        margin-top: 8px;
        margin-bottom: 4px;
    }

    .find-row input {
        flex: 1;
        margin: 0;
    }

    .find-btn {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 13px 22px;
        background: var(--gradient-em);
        color: var(--text) !important;
        border: 1px solid var(--border-strong);
        border-radius: var(--radius-sm);
        font-size: 11px;
        font-weight: 700;
        letter-spacing: 0.13em;
        text-transform: uppercase;
        font-family: 'Inter', sans-serif;
        cursor: pointer;
        white-space: nowrap;
        flex-shrink: 0;
        transition: all .22s cubic-bezier(0.22,1,0.36,1);
        margin: 0;
    }
    .find-btn:hover {
        border-color: var(--primary);
        box-shadow: 0 0 28px -6px rgba(39,180,135,0.3);
        transform: translateY(-1px);
    }

    /* ─── RECIPIENT DETAILS CARD ─── */
    .recipient-card {
        background: var(--surface-2);
        border: 1px solid var(--border-strong);
        border-radius: var(--radius);
        padding: 24px 28px;
        margin-top: 20px;
        margin-bottom: 4px;
        position: relative;
        overflow: hidden;
    }

    /* left accent bar */
    .recipient-card::before {
        content: "";
        position: absolute;
        top: 0; left: 0; bottom: 0;
        width: 3px;
        background: var(--gradient-gold);
        border-radius: 3px 0 0 3px;
    }

    .recipient-header {
        font-size: 9px;
        font-weight: 700;
        letter-spacing: 0.28em;
        text-transform: uppercase;
        color: var(--muted);
        margin-bottom: 20px;
    }

    .recipient-row {
        display: flex;
        align-items: center;
        gap: 20px;
        padding: 10px 0;
        border-bottom: 1px solid var(--border);
    }
    .recipient-row:last-child { border-bottom: none; padding-bottom: 0; }
    .recipient-row:first-of-type { padding-top: 0; }

    .r-label {
        font-size: 9.5px;
        font-weight: 700;
        letter-spacing: 0.2em;
        text-transform: uppercase;
        color: var(--muted);
        width: 100px;
        flex-shrink: 0;
    }

    .r-value {
        font-family: 'JetBrains Mono', monospace;
        font-size: 14px;
        font-weight: 500;
        color: var(--champagne);
        letter-spacing: 0.04em;
    }

    /* ─── TRANSFER DETAILS SECTION ─── */
    .transfer-section {
        margin-top: 24px;
    }

    .section-divider {
        display: flex;
        align-items: center;
        gap: 14px;
        margin-bottom: 4px;
    }
    .section-divider-label {
        font-size: 9px;
        font-weight: 700;
        letter-spacing: 0.28em;
        text-transform: uppercase;
        color: var(--muted);
        white-space: nowrap;
    }
    .section-divider-line {
        flex: 1;
        height: 1px;
        background: var(--border);
    }

    /* ─── SEND BUTTON ─── */
    .send-btn {
        display: inline-flex;
        align-items: center;
        gap: 10px;
        padding: 14px 32px;
        background: var(--gradient-gold);
        color: var(--ink) !important;
        border: none;
        border-radius: var(--radius-sm);
        font-size: 11.5px;
        font-weight: 700;
        letter-spacing: 0.14em;
        text-transform: uppercase;
        font-family: 'Inter', sans-serif;
        cursor: pointer;
        margin-top: 24px;
        transition: all .25s cubic-bezier(0.22,1,0.36,1);
        box-shadow: 0 4px 18px rgba(212,176,106,0.18);
    }
    .send-btn:hover {
        box-shadow: 0 8px 30px rgba(212,176,106,0.35);
        transform: translateY(-1px);
    }
    .send-btn:active { transform: translateY(0); }

    /* ─── LIMIT NOTE ─── */
    .limit-note {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-top: 20px;
        padding: 11px 16px;
        background: rgba(212,176,106,0.06);
        border: 1px solid rgba(212,176,106,0.15);
        border-radius: var(--radius-xs, 6px);
        font-size: 12px;
        color: rgba(212,176,106,0.7);
    }
</style>

<div class="send-layout">

    <!-- Step 1 -->
    <label>Recipient Account Number</label>
    <div class="find-row">
        <asp:TextBox ID="txtRecipientAcct" runat="server" TextMode="Number" placeholder="Enter account number" />
        <asp:Button ID="btnFind" runat="server" Text="Find Account" CssClass="find-btn" OnClick="btnFind_Click" />
    </div>
    <asp:Label ID="lblFindMsg" runat="server" />

    <!-- Recipient Details (shown after find) -->
    <asp:Panel ID="pnlRecipient" runat="server" Visible="false">

        <div class="recipient-card">
            <p class="recipient-header">Recipient Details</p>
            <div class="recipient-row">
                <span class="r-label">Account No.</span>
                <span class="r-value"><asp:Label ID="lblRAcct" runat="server" /></span>
            </div>
            <div class="recipient-row">
                <span class="r-label">Name</span>
                <span class="r-value"><asp:Label ID="lblRName" runat="server" /></span>
            </div>
        </div>

        <!-- Step 2: Transfer Details -->
        <div class="transfer-section">
            <div class="section-divider">
                <span class="section-divider-label">Transfer Details</span>
                <span class="section-divider-line"></span>
            </div>

            <label>Amount (Min 100, Max 2,000, multiples of 100)</label>
            <asp:TextBox ID="txtAmount" runat="server" TextMode="Number" placeholder="e.g. 500" />

            <label>Your Password (for verification)</label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter your password" />

            <div class="limit-note">
                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
                </svg>
                Recipient's total balance cannot exceed PHP 10,000.00
            </div>

            <asp:Button ID="btnSend" runat="server" Text="Send CloudMoney" CssClass="send-btn" OnClick="btnSend_Click" />
            <asp:Label ID="lblMsg" runat="server" />
        </div>

    </asp:Panel>

</div>

</asp:Content>
