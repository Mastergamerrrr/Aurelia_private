<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="StatementOfAccount.aspx.cs" Inherits="BANKAPPPROJECT.StatementOfAccount" %>

<asp:Content ID="c1" ContentPlaceHolderID="MainContent" runat="server">

<h2>Statement of Account</h2>

<style>
    .report-layout { max-width: 960px; }

    /* ─── DATE ROW ─── */
    .date-row {
        display: grid;
        grid-template-columns: 1fr 1fr auto;
        gap: 12px;
        align-items: flex-end;
        margin-bottom: 8px;
    }

    .date-field { display: flex; flex-direction: column; }

    .date-label {
        font-size: 9.5px;
        font-weight: 700;
        color: var(--muted);
        text-transform: uppercase;
        letter-spacing: 0.22em;
        margin-bottom: 7px;
    }

    .date-input-wrap {
        position: relative;
        cursor: pointer;
        display: block;
    }

    .date-input-wrap input[type=date] {
        width: 100%;
        padding: 13px 44px 13px 16px;
        border: 1px solid var(--border-strong);
        border-radius: var(--radius-sm);
        font-size: 14px;
        font-family: 'JetBrains Mono', monospace;
        color: var(--text);
        background: var(--bg);
        outline: none;
        cursor: pointer;
        transition: border-color .2s ease, box-shadow .2s ease, background .2s ease;
        -webkit-appearance: none;
        appearance: none;
        margin: 0;
    }

    .date-input-wrap input[type=date]:hover,
    .date-input-wrap input[type=date]:focus {
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(39,180,135,0.12);
        background: var(--surface-2);
    }

    /* Custom icon overlay */
    .date-input-wrap .cal-icon {
        position: absolute;
        right: 13px;
        top: 50%;
        transform: translateY(-50%);
        pointer-events: none;
        color: var(--muted);
    }

    /* Stretch browser's native picker trigger across the full input */
    .date-input-wrap input[type=date]::-webkit-calendar-picker-indicator {
        position: absolute;
        inset: 0;
        width: 100%;
        height: 100%;
        opacity: 0;
        cursor: pointer;
    }

    .list-btn {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 13px 28px;
        background: var(--gradient-gold);
        color: var(--ink) !important;
        border: none;
        border-radius: var(--radius-sm);
        font-size: 11px;
        font-weight: 700;
        letter-spacing: 0.14em;
        text-transform: uppercase;
        font-family: 'Inter', sans-serif;
        cursor: pointer;
        transition: all .22s cubic-bezier(0.22,1,0.36,1);
        white-space: nowrap;
        box-shadow: 0 4px 16px rgba(212,176,106,0.18);
        align-self: flex-end;
        margin: 0;
    }
    .list-btn:hover {
        box-shadow: 0 8px 28px rgba(212,176,106,0.32);
        transform: translateY(-1px);
    }

    /* ─── RESULTS ─── */
    .results-card {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: var(--radius);
        overflow: hidden;
        box-shadow: var(--shadow-sm);
        margin-top: 20px;
    }

    .results-card table { margin: 0; }

    .results-card table th {
        background: var(--surface-2);
        color: var(--muted);
        font-size: 9px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.2em;
        padding: 13px 16px;
        border-bottom: 1px solid var(--border-strong);
        white-space: nowrap;
        text-align: left;
    }

    .results-card table td {
        padding: 13px 16px;
        border-bottom: 1px solid var(--border);
        color: var(--text);
        font-family: 'JetBrains Mono', monospace;
        font-size: 12px;
        vertical-align: middle;
    }

    .results-card table td:first-child {
        font-family: 'Inter', sans-serif;
        color: var(--muted);
        font-size: 11px;
        width: 36px;
    }

    .results-card table tr:last-child td { border-bottom: none; }
    .results-card table tr:hover td { background: rgba(212,176,106,0.025); }

    .debit-val  { color: var(--danger); }
    .credit-val { color: var(--primary); }
    .null-val   { color: var(--muted); opacity: 0.4; }

    @media (max-width: 680px) {
        .date-row { grid-template-columns: 1fr 1fr; }
        .date-row .list-btn { grid-column: 1 / -1; }
    }
    @media (max-width: 420px) {
        .date-row { grid-template-columns: 1fr; }
    }
</style>

<div class="report-layout">

    <div class="date-row">
        <div class="date-field">
            <span class="date-label">From</span>
            <div class="date-input-wrap">
                <asp:TextBox ID="txtFrom" runat="server" TextMode="Date" />
                <svg class="cal-icon" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                    <rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/>
                    <line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
                </svg>
            </div>
        </div>

        <div class="date-field">
            <span class="date-label">To</span>
            <div class="date-input-wrap">
                <asp:TextBox ID="txtTo" runat="server" TextMode="Date" />
                <svg class="cal-icon" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75">
                    <rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/>
                    <line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
                </svg>
            </div>
        </div>

        <asp:Button ID="btnList" runat="server" Text="List" CssClass="list-btn" OnClick="btnList_Click" />
    </div>

    <asp:Label ID="lblMsg" runat="server" />

    <asp:Panel ID="pnlResults" runat="server" Visible="false">
        <div class="results-card">
            <table>
                <tr>
                    <th>#</th>
                    <th>Type</th>
                    <th>Date</th>
                    <th>Debit</th>
                    <th>Credit</th>
                    <th>Balance</th>
                    <th>Sent To</th>
                    <th>Received From</th>
                </tr>
                <asp:Repeater ID="rptStatement" runat="server">
                    <ItemTemplate>
                        <tr>
                            <td><%# Container.ItemIndex + 1 %></td>
                            <td><%# Eval("TxnType") %></td>
                            <td><%# Eval("TxnDate", "{0:MM/dd/yyyy hh:mm tt}") %></td>
                            <td class="debit-val"><%# (Eval("TxnType").ToString() == "Withdraw" || Eval("TxnType").ToString() == "Send") ? string.Format("{0:N2}", Eval("Amount")) : "" %></td>
                            <td class="credit-val"><%# (Eval("TxnType").ToString() == "Deposit" || Eval("TxnType").ToString() == "Receive") ? string.Format("{0:N2}", Eval("Amount")) : "" %></td>
                            <td><%# Eval("Balance", "{0:N2}") %></td>
                            <td><%# Eval("SentToAcctNo") %></td>
                            <td><%# Eval("ReceivedFromAcctNo") %></td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </table>
        </div>
    </asp:Panel>

</div>

<script>
    (function () {
        document.querySelectorAll('.date-input-wrap').forEach(function (wrap) {
            var inp = wrap.querySelector('input[type=date]');
            if (!inp) return;
            // Clicking anywhere on the wrapper opens the picker
            wrap.addEventListener('click', function () {
                inp.focus();
                try { inp.showPicker(); } catch (e) { }
            });
        });
    })();
</script>

</asp:Content>
