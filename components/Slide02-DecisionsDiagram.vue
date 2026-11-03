<template>
  <div class="goal-decisions">
    <div class="stage">
      <!-- Left: identity and traffic -->
      <section class="card" style="left: 0; top: 0; width: 300px; height: 80px">
        <carbon-user-identification class="icon c-violet" style="left: 22.75px; top: 14px" />
        <strong class="label" style="left: 58px; top: 12px">OIDC</strong>
        <div class="seg seg-center c-violet" style="top: 44px"><span>truster</span><span>other</span></div>
      </section>

      <section class="card" style="left: 0; top: 91px; width: 300px; height: 252px">
        <carbon-branch class="icon c-orange" style="left: 20.5px; top: 16px" />
        <strong class="label" style="left: 58px; top: 14px">Ingress</strong>
        <div class="seg c-orange" style="left: 25px; top: 54px"><span>nlb</span><span>tunnel</span></div>
        <div class="branch" style="left: 117px; top: 80px" />
        <div class="seg c-orange" style="left: 40px; top: 88px"><span>cloudflare-tunnel</span><span>ngrok</span></div>
        <div class="lane lane-violet" style="left: 20px; top: 123px">
          <carbon-terminal class="lane-icon" />
          <strong>Kubernetes API</strong>
          <small>Required</small>
        </div>
        <div class="lane lane-orange" style="left: 20px; top: 186px">
          <carbon-earth class="lane-icon" />
          <strong>HTTP(S)</strong>
          <small>Optional</small>
        </div>
      </section>

      <section class="card" style="left: 0; top: 354px; width: 300px; height: 145px">
        <carbon-network-4 class="icon c-violet" style="left: 22px; top: 16px" />
        <strong class="label" style="left: 58px; top: 14px">DNS</strong>
        <div class="seg seg-col seg-center c-violet" style="top: 50px; width: 180px">
          <span>aws-route53</span><span>google-cloud-dns</span><span>cloudflare-dns</span>
        </div>
      </section>

      <section class="card" style="left: 0; top: 510px; width: 300px; height: 80px">
        <carbon-certificate class="icon c-orange" style="left: 22px; top: 14px" />
        <strong class="label" style="left: 58px; top: 12px">ACME</strong>
        <div class="seg seg-center c-orange" style="top: 44px"><span>letsencrypt</span><span>other</span></div>
      </section>

      <!-- Centre: infrastructure -->
      <section class="infra" style="left: 340px; top: 0; width: 650px; height: 590px">
        <strong class="label label-lg" style="left: 30px; top: 14px">Infrastructure</strong>
        <div class="seg c-blue" style="left: 194px; top: 15px">
          <span>aws</span><span>google</span><span>proxmox</span><span>local</span>
        </div>
        <div class="card iam" style="left: 510px; top: 10px; width: 120px; height: 32px">
          <carbon-security class="icon c-blue" style="left: 12px; top: 7px; width: 18px; height: 18px" />
          <strong class="label label-xs" style="left: 38px; top: 5px">IAM</strong>
        </div>

        <section class="card vpc" style="left: 20px; top: 56px; width: 610px; height: 500px">
          <span class="mono-label" style="left: 24px; top: 15px">VPC, Subnet(s), Route Tables</span>

          <section class="vm" style="left: 65px; top: 55px; width: 480px; height: 240px">
            <carbon-bare-metal-server class="icon c-blue" style="left: 24px; top: 20px" />
            <strong class="label" style="left: 58px; top: 21px">VMs</strong>
            <span class="mono c-blue" style="left: 120px; top: 25px">EC2 · GCE · Qemu</span>
            <div class="seg seg-fixed c-blue" style="left: 312px; top: 18px"><span>instance count</span></div>
            <div class="seg seg-fixed c-blue" style="left: 312px; top: 50px"><span>arm64</span><span>amd64</span></div>
            <div class="seg seg-fixed c-blue" style="left: 312px; top: 82px"><span>instance size</span></div>
            <div class="seg seg-fixed c-blue" style="left: 312px; top: 114px"><span>root disk size</span></div>

            <div class="node node-violet" style="left: 20px; top: 71px; width: 200px; height: 64px">
              <carbon-kubernetes class="node-icon" />
              <strong>Kubernetes API</strong>
            </div>
            <div class="node node-orange" style="left: 20px; top: 160px; width: 200px; height: 62px">
              <carbon-direction-fork class="node-icon" />
              <div>
                <strong>Ingress Controller</strong>
                <span class="mono">envoy-gateway</span>
              </div>
            </div>
            <div class="node node-orange" style="left: 240px; top: 160px; width: 220px; height: 62px">
              <carbon-container-software class="node-icon" />
              <strong>Workload Pod</strong>
            </div>
          </section>

          <section class="card" style="left: 75px; top: 365px; width: 480px; height: 59px">
            <carbon-upload class="icon c-blue" style="left: 20px; top: 17px" />
            <strong class="label" style="left: 51px; top: 15px">NAT</strong>
            <div class="seg c-blue" style="left: 130px; top: 16px"><span>managed nat gateway</span><span>nat instance</span></div>
          </section>

          <!-- Network choices sit along the bottom of the VPC box. -->
          <div class="seg-row" style="top: 456px">
            <div class="seg c-blue"><span>region</span></div>
            <div class="seg c-blue"><span>zone(s)</span></div>
            <div class="seg c-blue"><span>ipv4 cidr block</span></div>
            <div class="seg c-blue"><span>dual-stack</span><span>ipv6</span></div>
          </div>
        </section>
      </section>

      <!-- Right: cloud services the cluster uses -->
      <section class="card" style="left: 1030px; top: 0; width: 300px; height: 150px">
        <carbon-document class="icon c-violet" style="left: 22px; top: 22px" />
        <strong class="label" style="left: 58px; top: 20px">Object Storage</strong>
        <div class="seg seg-center c-violet" style="top: 88px"><span>s3</span><span>gcs</span></div>
      </section>

      <section class="card" style="left: 1030px; top: 170px; width: 300px; height: 150px">
        <carbon-vmdk-disk class="icon c-violet" style="left: 22px; top: 14px" />
        <strong class="label" style="left: 58px; top: 12px">Volume Storage</strong>
        <div class="seg seg-col seg-center c-violet" style="top: 52px; width: 160px">
          <span>aws-ebs</span><span>gce-pd</span><span>openebs-lvm</span>
        </div>
      </section>

      <section class="card" style="left: 1030px; top: 340px; width: 300px; height: 250px">
        <carbon-password class="icon c-violet" style="left: 22px; top: 14px" />
        <strong class="label" style="left: 58px; top: 12px">Secrets</strong>
        <div class="seg seg-col seg-center c-violet" style="top: 64px; width: 250px">
          <span>aws-secrets-manager</span><span>aws-parameter-store</span><span>google-secret-manager</span><span>openbao</span><span>vault</span>
        </div>
      </section>

      <!-- Connectors -->
      <svg class="wires" viewBox="0 0 1330 590" aria-hidden="true">
        <defs>
          <marker v-for="m in markers" :id="`goal-head-${m}`" :key="m" markerHeight="7" markerWidth="7" orient="auto" refX="6" refY="3.5" viewBox="0 0 7 7" markerUnits="userSpaceOnUse">
            <path d="M0 0 L7 3.5 L0 7 z" :class="`fill-${m}`" />
          </marker>
        </defs>
        <path class="wire wire-violet" d="M280 224.5 H444" marker-end="url(#goal-head-violet)" />
        <path class="wire wire-orange wire-dashed" d="M280 298 H444" marker-end="url(#goal-head-orange)" />
        <path class="wire wire-orange" d="M645 302 H664" marker-end="url(#goal-head-orange)" />
        <path class="wire wire-violet" d="M445 205.5 H320 V50 H302" marker-end="url(#goal-head-violet)" />
        <path class="wire wire-orange" d="M445 318 H320 V550 H302" marker-end="url(#goal-head-orange)" />
        <path class="wire wire-violet" d="M905 190 H1010 V75 H1029" marker-end="url(#goal-head-violet)" />
        <path class="wire wire-violet" d="M885 292 H1029" marker-end="url(#goal-head-violet)" />
        <path class="wire wire-violet" d="M885 314 H1010 V465 H1029" marker-end="url(#goal-head-violet)" />
        <path class="wire wire-blue" d="M655.5 351 V420" marker-end="url(#goal-head-blue)" />
      </svg>
    </div>
  </div>
</template>

<script setup lang="ts">
const markers = ['blue', 'violet', 'orange']
</script>

<style scoped>
/* 868px is the slide content width; the design grid is 1330px wide. */
.goal-decisions {
  --scale: calc(868 / 1330);
  --blue: var(--podplane-blue);
  --violet: #6d3fd8;
  --orange: #c2570c;
  height: calc(610px * var(--scale));
  margin-top: 24px;
  position: relative;
  width: 868px;
}

.stage {
  height: 590px;
  left: 0;
  position: absolute;
  top: 0;
  transform: scale(var(--scale));
  transform-origin: top left;
  width: 1330px;
}

.stage section,
.stage .card,
.stage .seg,
.stage .icon,
.stage .label,
.stage .mono,
.stage .mono-label,
.stage .lane,
.stage .node,
.stage .branch {
  position: absolute;
}

.c-blue { color: var(--blue); }
.c-violet { color: var(--violet); }
.c-orange { color: var(--orange); }

.card {
  background: #fff;
  /* Outlines, not borders, so nested absolute positions match the design grid. */
  outline: 1.5px solid #d7deea;
  outline-offset: -1.5px;
  border-radius: 18px;
}

.infra {
  background: var(--podplane-surface);
  outline: 1.5px solid #c3ccda;
  outline-offset: -1.5px;
  border-radius: 24px;
}

.vm {
  background: #f8fafc;
  outline: 1.5px solid #b9c4d4;
  outline-offset: -1.5px;
  border-radius: 18px;
}

.icon {
  height: 24px;
  width: 24px;
}

.label {
  color: var(--podplane-ink);
  font-size: 21px;
  font-weight: 700;
  letter-spacing: -0.02em;
  line-height: 26px;
  white-space: nowrap;
}

.label-lg { font-size: 23px; }
.label-sm { font-size: 19px; }
.label-xs { font-size: 17px; }

.mono,
.mono-label,
.seg {
  font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
}

.mono {
  font-size: 14px;
  white-space: nowrap;
}

.mono-label {
  color: var(--podplane-muted);
  font-size: 14px;
  font-weight: 700;
  white-space: nowrap;
}

/* Segmented option pills: one cell per choice. */
.seg {
  background: #fff;
  border: 1.5px solid #c9d2df;
  border-radius: 13px;
  display: flex;
  font-size: 15px;
  height: 26px;
  overflow: hidden;
}

.seg span {
  align-items: center;
  display: flex;
  justify-content: center;
  padding: 0 12px;
  white-space: nowrap;
}

.seg span + span {
  border-left: 1.5px solid #c9d2df;
}

.seg-center {
  left: 50%;
  transform: translateX(-50%);
}

/* A centred row of pills; the pills flow inside it instead of being placed. */
.seg-row {
  display: flex;
  gap: 10px;
  justify-content: center;
  left: 0;
  position: absolute;
  width: 100%;
}

.stage .seg-row .seg {
  position: static;
}

.seg-fixed {
  min-width: 150px;
}

.seg-fixed span {
  flex: 1;
}

.seg-col {
  flex-direction: column;
  height: auto;
}

.seg-col span {
  height: 26px;
}

.seg-col span + span {
  border-left: 0;
  border-top: 1.5px solid #c9d2df;
}

.branch {
  background: var(--orange);
  height: 8px;
  width: 2px;
}

/* Traffic lanes in the Ingress card. */
.lane {
  align-items: center;
  border-radius: 12px;
  display: flex;
  gap: 8px;
  height: 52px;
  padding: 0 12px;
  width: 260px;
}

.lane strong {
  color: var(--podplane-ink);
  font-size: 16px;
  white-space: nowrap;
}

.lane small {
  font-size: 12px;
  font-weight: 800;
  margin-left: auto;
  text-transform: uppercase;
}

.lane-icon {
  flex: 0 0 auto;
  height: 20px;
  width: 20px;
}

.lane-violet {
  background: #f1edff;
  border: 1.5px solid #bfb0f5;
  color: var(--violet);
}

.lane-orange {
  background: #fff4e8;
  border: 1.5px solid #ecc7a1;
  color: var(--orange);
}

/* Components running on the VMs. */
.node {
  align-items: center;
  border-radius: 12px;
  display: flex;
  gap: 10px;
  line-height: 1.2;
  padding: 0 14px;
}

.node strong {
  color: var(--podplane-ink);
  display: block;
  font-size: 17px;
  white-space: nowrap;
}

.node .mono {
  color: var(--podplane-muted);
  display: block;
  font-size: 12px;
  margin-top: 3px;
  position: static;
}

.node-icon {
  flex: 0 0 auto;
  height: 20px;
  width: 20px;
}

.node-violet {
  background: #f1edff;
  border: 1.5px solid #9d86ef;
  color: var(--violet);
}

.node-orange {
  background: #fff4e8;
  border: 1.5px solid #e2ac78;
  color: var(--orange);
}

/* Connectors drawn over the boxes. */
.wires {
  height: 590px;
  left: 0;
  overflow: visible;
  pointer-events: none;
  position: absolute;
  top: 0;
  width: 1330px;
}

.wire {
  fill: none;
  stroke-linecap: round;
  stroke-linejoin: round;
  stroke-width: 2;
}

.wire-thick { stroke-width: 3; }
.wire-dashed { stroke-dasharray: 10 7; stroke-linecap: butt; }
.wire-blue { stroke: var(--blue); }
.wire-violet { stroke: var(--violet); }
.wire-orange { stroke: var(--orange); }
.fill-blue { fill: var(--blue); }
.fill-violet { fill: var(--violet); }
.fill-orange { fill: var(--orange); }
</style>
