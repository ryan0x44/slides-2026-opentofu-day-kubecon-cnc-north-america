---
theme: apple-basic
title: "Building My Own IaC Engine Was a Mistake: Why I Now Use OpenTofu"
info: |
  A talk for OpenTofu Day at KubeCon + CloudNativeCon North America 2026.
  Licensed under Creative Commons Attribution 4.0 International.
author: Ryan Djurovich
colorSchema: light
download: true
exportFilename: slides
# Talk slot: 25 min, incl. ~5 min Q&A. Aim for 12-14 min of slides plus a 4-8 min demo.
duration: 14min
transition: slide-left
mdc: true
---

<div class="opening-content">
  <div class="question">Building My Own IaC Engine<br />Was a Mistake:<br><span class="accent">Why I Now Use OpenTofu</span></div>
</div>

---
class: goal-slide
---

<script setup>
import DecisionsDiagram from './components/Slide02-DecisionsDiagram.vue'
</script>

# The goal: <span class="accent">a Kubernetes PaaS in 6-18 decisions + 1 click</span>

<DecisionsDiagram />

---

# Why not OpenTofu? <span class="accent">Serverless</span>

<p class="subheading">The hypothesis: a serverless control plane and provisioner would be reliable, cheap, and easy to operate.</p>

<div class="talk-grid">
  <div class="talk-card talk-card-muted"><small>Option A</small><h3>Compile OpenTofu to WebAssembly</h3><ul><li>Large binaries, slow cold starts, and more memory than TypeScript would need.</li><li>Providers run as separate plugin processes, which an isolate can't spawn.</li></ul></div>
  <div class="talk-card talk-card-accent"><small>Option B</small><h3>Call the Cloud SDKs from TypeScript</h3><ul><li>A fixed scope: ~40 resources on 3 clouds, not a general-purpose IaC engine.</li><li>Every cloud provider had a mature and lightweight TypeScript SDK available.</li></ul></div>
</div>

<div class="takeaway">I chose the Cloud SDKs. <strong>It worked... until it didn't.</strong></div>

---
class: v1-slide
---

# Version 1: <span class="accent">Stateless Reconciliation</span>

<div class="step-flow">
  <div class="talk-card"><small>01</small><h3>Expected state</h3><p>Determine the infra we want</p></div>
  <span>→</span>
  <div class="talk-card"><small>02</small><h3>Query the cloud</h3><p>Discover what exists now</p></div>
  <span>→</span>
  <div class="talk-card talk-card-accent"><small>03</small><h3>Reconcile</h3><p>Create, update, or delete</p></div>
</div>

<div class="chip-row">
  <strong>Benefits:</strong><span>No database</span><span>Cheap</span><span>Fast happy path</span><span>Operationally simple</span>
</div>

<div class="section-rule"><strong>Avoiding state introduces challenges</strong></div>

<div class="talk-grid talk-three">
  <div class="talk-card"><h3><carbon-document-audio />Audit history</h3><p>It created resources ($$) for customers, so what did the engine attempt?</p></div>
  <div class="talk-card"><h3><carbon-list-boxes />Resource inventory</h3><p>It manages resources ($$) for customers, so what is this cluster responsible for?</p></div>
  <div class="talk-card"><h3><carbon-renew />Failures & retries</h3><p>Each run starts fresh, with no record of past attempts to back off on or give up after.</p></div>
</div>

<div class="takeaway">If you need a durable audit log and resource list, <strong>you might as well have a database.</strong></div>

---

# By Version 4: <span class="accent">Starting To Look Like OpenTofu?</span>

<div class="timeline">
  <div class="timeline-event"><span class="timeline-marker">V2</span><div class="talk-card"><div class="card-main"><h3>Serverless + SQLite</h3><p>A resource inventory and audit log.</p></div><p class="card-friction">Migrations and table locks, write concurrency, other limitations.</p></div></div>
  <div class="timeline-event"><span class="timeline-marker">V3</span><div class="talk-card"><div class="card-main"><h3>Serverless + PostgreSQL</h3><p>Faster schema iteration and scalability.</p></div><p class="card-friction">Limited by which providers Serverless could connect to.</p></div></div>
  <div class="timeline-event timeline-event-accent"><span class="timeline-marker">Feedback</span><div class="talk-card talk-card-accent quote-card"><div class="card-main"><blockquote>Can we get a Terraform-like view?</blockquote><p class="quote-attribution"><carbon-user-avatar />Pre-beta tester</p></div><p class="card-friction">Requires plans, ability to preview changes and show progress.</p></div></div>
  <div class="timeline-event timeline-event-bug"><span class="timeline-marker">V4</span><div class="talk-card"><div class="card-main"><h3>Dependency Graph</h3><p>Efficiently retry or reschedule a failed plan.</p></div><p class="card-friction card-friction-bug">Super buggy and hard to get right.</p></div></div>
  <div class="timeline-event"><span class="timeline-marker">Production</span><div class="talk-card"><div class="card-main"><h3>PostgreSQL via Tunnels</h3><p>Our preferred PostgreSQL setup needed a tunnel.</p></div><p class="card-friction">Using tunnels required running containers or VMs.</p></div></div>
</div>

---

# Market Feedback: <span class="accent">IaC Is The Expectation</span>

<div class="stat-strip"><strong>62–73%</strong><span>of infrastructure engineers use Terraform or OpenTofu</span></div>

<div class="talk-grid market-grid">
  <div class="talk-card talk-card-accent quote-card"><small>What potential customers expected</small><blockquote>Can we take it and run it ourselves if we need to?</blockquote><blockquote>Can we see plan/apply output like Terraform?</blockquote></div>
  <div class="talk-card talk-card-muted"><small>What the prototype showed</small><ul class="lesson-rows"><li>Stateless didn't work → a database is required.</li><li>Tunnels are required → VMs or containers are required.</li><li>The dependency graph was the hardest part.</li><li>A custom IaC engine wouldn't differentiate the product.</li></ul></div>
</div>

<div class="takeaway">The market expects IaC. We needed a DB + servers. <strong>What if we removed Serverless, and used OpenTofu?</strong></div>

<!--
Stat: "62–73% of infrastructure engineers use Terraform or OpenTofu."

Low end, 62.5%: Stack Overflow Developer Survey 2026, raw responses (ODbL 1.0)
- Results: https://survey.stackoverflow.co/2026
- Data: https://github.com/StackExchange/Survey/tree/main/packages/archive/2026 (survey_results_public.csv)
- Filter: Role = "DevOps engineer or professional", "Cloud infrastructure engineer", or "Site reliability engineer".
- Base: respondents who answered CloudPlatHaveWorkedWith (not NA), n = 493.
- Count: selections that include "Terraform" or "OpenTofu".
- Infra roles: Terraform 58.6%, OpenTofu 15.8%, either 62.5%.
- Cloud infrastructure engineer (n=119) 70.6%; DevOps (n=309) 59.2%; SRE (n=65) 63.1%.
- All respondents (n=10,759): Terraform 18.6%, OpenTofu 3.6%, either 19.8%.
- Excluded system administrators (n=117, either 12.8%): mostly on-prem/ops roles.
- Check: the all-respondents OpenTofu figure (3.6%) matches the published site figure.

High end, 73%: Firefly, The State of IaC 2026 report
- https://cdn.prod.website-files.com/644656ba41efb6aaeae93c9c/69dccd5a2b1814f81d352882_9265236e48920b59a43f57837e976567_The%20State%20of%20IaC%202026%20Report.pdf
- "Terraform remains the dominant IaC framework at 73% usage." 41% using, migrating to, or planning OpenTofu.
- Caveat: vendor survey of "hundreds" of infrastructure professionals.
- Related, not used in the range: Firefly State of IaC 2025 says 89% have adopted IaC of any kind (https://www.firefly.ai/state-of-iac-2025).
-->

---

# Starting Again: <span class="accent">Open Source, Serverless-less, OpenTofu</span>

<p class="subheading">Without Serverless, OpenTofu is viable and already does state, plans, dependencies, and safe retries.</p>

<div class="section-rule"><strong>Rethinking requirements to meet market needs</strong></div>

<ul class="checklist">
  <li><h3>Same Product Experience</h3><p>6-18 decisions → cluster config file. One command to deploy.</p></li>
  <li><h3>Escape Hatches</h3><p>OpenTofu files are generated from the cluster config file.<br />You must be able to override, not restricted by the abstraction.</p></li>
  <li><h3>CLI-first</h3><p>CLI orchestrates OpenTofu. No SaaS or server(less) required.</p></li>
  <li><h3>State in your bucket</h3><p>OpenTofu state in an object storage bucket in your cloud account.</p></li>
</ul>

---

<script setup>
import ExecutionPath from './components/Slide07-ExecutionPath.vue'
</script>

# The Plan For SaaS? <span class="accent">It Just Runs the CLI</span>

<ExecutionPath />

---

# Open Source Demo: <span class="accent">6 Questions → OpenTofu Apply</span>

<div class="demo-grid">
  <div class="demo-steps">
    <div><span>1</span><strong>Answer a few questions</strong><small>Writes podplane.cluster.jsonc</small></div>
    <div><span>2</span><strong>Generate files</strong><small>OpenTofu files, ready to commit</small></div>
    <div><span>3</span><strong>Plan & apply</strong><small>OpenTofu JSONL output → progress UX</small></div>
    <div><span>4</span><strong>Review the result</strong><small>Resources created, state in your account</small></div>
  </div>

```bash
brew install podplane/tap/podplane
# OR:
# go install github.com/podplane/podplane@latest

podplane cluster create --no-apply
# questions → podplane.cluster.jsonc → *.tf

podplane cluster create -f podplane.cluster.jsonc
# OpenTofu plan & apply
```

</div>

<div class="takeaway"><strong>Podplane 0.x developer preview</strong>: open source today.</div>

---

# OpenTofu: <span class="accent">A Great Platform To Build On</span>

<div class="project-cards closing-project">
  <a class="project-card project-card-featured" href="https://github.com/podplane/podplane">
    <img class="project-logo project-logo-podplane" src="https://podplane.dev/podplane-logo.svg" alt="Podplane" />
    <div class="project-github">
      <strong>Podplane is open source, Apache 2.0</strong>
      <span class="github-repo"><carbon-logo-github />podplane/podplane</span>
    </div>
    <ProjectQr value="https://github.com/podplane/podplane" :size="110" />
  </a>
</div>

<div class="section-rule"><strong>Key Learnings</strong></div>

<div class="talk-grid closing-points">
  <div class="talk-card"><h3>Just use containers</h3><p>Most tools, OpenTofu included, want a normal machine. Save serverless for the jobs that clearly fit it.</p></div>
  <div class="talk-card"><h3>Build on OpenTofu</h3><p>It's an excellent base for your product. If you think you need your own engine, question that assumption first.</p></div>
</div>

<div class="final-contact">
  <span class="text-sm font-bold">Ryan Djurovich:</span>
  <a href="https://x.com/ryan0x44"><carbon-logo-x />@ryan0x44</a>
  <a href="https://github.com/ryan0x44"><carbon-logo-github />ryan0x44</a>
  <a href="https://ryan0x44.com"><carbon-earth />ryan0x44.com</a>
</div>
