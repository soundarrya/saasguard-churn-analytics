# Architecture – SaaSGuard Churn Early Warning

## 1) What We're Actually Tracking

The entire system is built around one simple truth about SaaS businesses:

> **If people stop opening dashboards → they're not getting value → they're going to cancel.**

So instead of tracking a hundred different things, we focus laser-sharp on the one metric that matters most: **dashboard usage over time.**

**The logic is simple:**
- Customer opens dashboards regularly = they're finding value = they'll stay
- Customer stops opening dashboards = they've lost interest = churn risk

This whole architecture is designed to catch that decline before it's too late.

---

## 2) How the Database Is Organized

Think of this like organizing customer information into logical groups:

| Table Name | What It Stores | Why We Need It |
|---|---|---|
| **DimCustomerAccount** | The enterprise companies using our product | Because the *account* is what churns, not individual users. We need to see company-level trends. |
| **DimUserProfile** | Individual people within each company | Because we need to see which users are active vs. inactive within an account. |
| **DimDate** | Calendar dates | Because we're tracking usage *over time*—30 days ago vs. today. |
| **FactDashboardUsage** | Every dashboard view by every user, every day | This is the heartbeat of the system—the raw activity data we analyze. |

**Why this structure?** It's the standard way real SaaS companies organize usage data for churn analytics. Clean, scalable, and easy to query.

---

## 3) How We Store Activity Data

**The level of detail matters.** Here's how we track usage:

**One row in FactDashboardUsage = One user's dashboard activity on one specific day**

**Example:**

| Account | User | Date | Dashboard Views |
|---|---|---|---|
| FinNova Corp | Sarah (User-32) | Oct 31, 2025 | 4 |
| FinNova Corp | Sarah (User-32) | Nov 1, 2025 | 0 |
| FinNova Corp | Sarah (User-32) | Nov 2, 2025 | 1 |

**Why this granularity?** Because we need to spot trends:
- Sarah used to check dashboards 4 times a day
- Now she's barely logging in
- That decline is a warning sign

This level of detail lets us compare "usage 60 days ago" vs. "usage in the last 30 days" and calculate if engagement is dropping.

---

## 4) How We Calculate Churn Risk (The Flow)

Here's how raw activity turns into actionable churn intelligence:

```
Step 1: Track dashboard views daily
    ↓
Step 2: Calculate "Daily Active Accounts" (how many accounts used dashboards today)
    ↓
Step 3: Compare usage windows (last 60 days vs. last 30 days)
    ↓
Step 4: Calculate "Drop Rate %" (how much usage declined)
    ↓
Step 5: Assign Risk Tier (LOW / MEDIUM / HIGH based on drop rate)
```

**Real-world example:**

- **FinNova Corp** had 50 dashboard views per week 60 days ago
- In the last 30 days, they only had 15 views per week
- That's a **70% drop**
- **Risk Tier = HIGH** → Customer Success should call them immediately

**This flow converts "Sarah viewed 4 dashboards" into "FinNova is at high churn risk."**

---

## 5) Why This Architecture Actually Works

This isn't just a "student project" design—it's built the way real SaaS companies structure churn analytics:

**It's based on real behavior, not guesswork**
- We're not asking customers "are you happy?" (they lie)
- We're watching what they actually do (usage doesn't lie)

**It's objective and transparent**
- No complex black-box algorithms
- Just clear SQL: "usage dropped X% = high risk"
- Product and Customer Success teams can understand exactly why an account is flagged

**It's fast and scalable**
- Can calculate churn risk daily (or even hourly if needed)
- Works for 10 customers or 10,000 customers

**It's actionable for multiple teams**
- Customer Success knows who to call
- Product knows which accounts are losing engagement
- Finance knows which revenue is at risk

**It predicts churn before it happens**
- Traditional approach: "Customer canceled" (too late)
- This approach: "Customer usage dropped 60%" (still time to save them)

---

## The Bottom Line

**This architecture gives SaaSGuard the power to predict churn before customers even think about canceling.**

Instead of reacting to cancellations, we're proactively identifying value decline.

**That's the difference between:**
- Losing a customer and scrambling to replace them
- Catching the problem early and re-engaging before they leave

And that difference? That's what keeps SaaS companies profitable and growing.

---

## What This Shows About My Skills

Building this architecture demonstrates I understand:

✓ How to structure data the way real SaaS companies do (dimensional modeling)  
✓ How to design for a specific business outcome (churn prediction, not just data storage)  
✓ How to make analytics fast, transparent, and actionable  
✓ How to think like both a data engineer AND a business strategist  

**I didn't just build a database—I built a churn prevention system.**
