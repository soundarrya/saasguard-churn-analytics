# SaaSGuard – Churn Early Warning Analytics

**Author:** Soundarya Sainathan  
**Target Role:** SQL Developer + Business Analyst (Hybrid)

---

## What This Project Is About

Every SaaS company faces the same nightmare: customers quietly stop using the product, then cancel their subscription a month later.

**By the time billing notices the cancellation, it's too late.**

This project tackles a smarter approach: **catch the problem before the customer even thinks about leaving.**

Here's the pattern we're tracking:
- Customer signs up excited about the product
- They use it heavily at first (building dashboards, analyzing data)
- Slowly, usage drops off
- They stop logging in
- Eventually, they cancel

**The key insight:** If we can spot when dashboard usage starts declining, we can intervene before they churn.

---

## The Business Problem 

Imagine you're running a SaaS company. You have hundreds of enterprise customers paying thousands of dollars per month.

**The question keeping you up at night:**
> "Which of my customers are about to cancel—and I just don't know it yet?"

**The traditional approach (reactive):**
- Wait until a customer cancels
- Scramble to save them
- Usually fail because they've already made up their mind

**The smart approach (proactive):**
- Track which customers are using the product less and less
- Flag them as "at risk" based on declining usage
- Reach out *before* they decide to leave
- Offer help, training, or solutions to re-engage them

**This project builds the analytics system that makes the smart approach possible.**

---

## What I Actually Built

This isn't theoretical—it's a working analytics system that answers the critical question:

> "Which enterprise customers have declining dashboard usage in the last 30 days and are now at high churn risk?"

**Why this matters:**
- Product teams need to know which features are losing engagement
- Customer Success teams need to know who to call
- Revenue teams need to protect annual recurring revenue (ARR)

---

## What's in This Project

| What You'll Find | What It Does |
|---|---|
| **`/sql` folder** | Database schema, realistic test data, and all the KPI queries |
| **`/docs` folder** | Full business case study, architecture explanation, KPI breakdown, and action recommendations |

Everything you need to understand both the technical work and the business thinking behind it.

---

## How the Database Works

Think of this as organizing customer behavior data so we can spot patterns:

**The Reference Tables (Dimensions):**
- **DimCustomerAccount** – The companies using our product
- **DimUserProfile** – Individual users within those companies
- **DimDate** – Calendar information for time-based analysis

**The Activity Table (Fact):**
- **FactDashboardUsage** – Every time someone views a dashboard, we track it

**Why this structure?** It mirrors how SaaS businesses actually think: "Which companies and users are doing what, and when?"

This is the industry-standard approach for usage-based churn detection.

---

## The Analytics That Matter

I built three key reports that convert raw usage data into churn intelligence:

| Report | What It Tells Us |
|---|---|
| **Daily Active Accounts** | Baseline: how many accounts are using the product each day |
| **Rolling 30-Day Drop Rate** | Red flag detector: which accounts show rapid usage decline over the last month |
| **Churn Risk Ranking** | Final answer: HIGH / MEDIUM / LOW risk labels for every account |

**These KPIs turn "people are using dashboards" into "Account XYZ is at high risk of canceling next month."**

---

## Why This Approach Works

Here's what makes this different from just tracking cancellations:

**Traditional approach:**
- Customer cancels → "Oh no, we lost them"
- Reactive, too late to save

**This approach:**
- Customer usage drops 40% over 30 days → "They're losing value, let's intervene"
- Proactive, there's still time to save them

**We're detecting value-churn, not just billing-churn.**

That means we catch the problem at the moment customers stop finding the product useful—not weeks later when they finally cancel.

---

## The Business Impact

This isn't just data—it's revenue protection:

**For Customer Success Teams:**
- Know exactly who to call and why
- "Hi, I noticed your team hasn't been using dashboards much lately—is everything okay?"
- Target outreach instead of random check-ins

**For Product Teams:**
- Understand which features are losing engagement
- "Dashboard usage is declining across mid-market accounts—what changed?"
- Fix product issues before they cause mass churn

**For Revenue Teams:**
- Protect ARR by saving at-risk accounts early
- "We identified 15 high-risk accounts worth $300K in ARR—here's the intervention plan"
- Turn churn prevention from reactive to strategic

---

## What This Project Shows About Me

Anyone can track who canceled. Not everyone can build a system that predicts who *will* cancel.

**This project demonstrates:**
- I understand how SaaS businesses actually operate (usage = value = retention)
- I can design analytics that answer strategic business questions, not just technical ones
- I know how to structure data the way real companies do (dimensional modeling)
- I can translate "declining dashboard views" into "high churn risk" in a way executives understand

**Bottom line:** I built a system that helps SaaS companies keep customers instead of losing them.

That's the kind of analytics work that directly impacts revenue.
