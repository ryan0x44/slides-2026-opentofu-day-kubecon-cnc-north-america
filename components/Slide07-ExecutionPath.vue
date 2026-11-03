<template>
  <div ref="root" class="execution-path">
    <section ref="ossLane" class="lane lane-oss">
      <span class="lane-label">Open Source · Podplane CLI</span>
      <div ref="questionsNode" class="node node-row node-questions"><carbon-chat /><span>Questions<small>or automation</small></span></div>
      <div ref="fileNode" class="node node-row node-file"><carbon-document /><span>Cluster config file<small>podplane.cluster.jsonc</small></span></div>
      <div ref="filesNode" class="node node-cli"><strong>OpenTofu files</strong><small>Generated from your config,<br />yours to review and override</small></div>
      <div class="inputs">
        <div ref="modulesNode"><carbon-cube />Opinionated modules</div>
        <div ref="providerNode"><carbon-plug />Custom provider</div>
      </div>
      <div ref="tofuNode" class="node node-tofu"><strong>OpenTofu</strong><small>plan · apply · graph</small></div>
      <div ref="stateNode" class="output"><carbon-object-storage />State bucket in your account</div>
    </section>

    <div class="runs-cli" />

    <section ref="managedLane" class="lane lane-managed">
      <span class="lane-label">Managed SaaS · Nadrama</span>
      <span class="lane-label lane-label-end">Coming soon</span>
      <div ref="nadramaNode" class="node node-row node-nadrama"><carbon-application-web /><span>Nadrama<small>UI, API, database</small></span></div>
      <div ref="workerNode" class="node node-worker"><strong>Worker Pool</strong><small>durable managed jobs</small></div>
      <div class="managed-note">Leave any time: take the config file<br />and state bucket with you.</div>
    </section>

    <svg class="connectors" :width="svgSize.width" :height="svgSize.height">
      <path v-for="(line, i) in lines" :key="i" :d="line.path" />
      <polygon v-for="(line, i) in lines.filter(l => l.head)" :key="`h${i}`" :points="line.head" />
    </svg>
    <div class="runs-label" :style="labelStyle">generates config and runs the same CLI</div>
  </div>
</template>

<script setup>
import { onBeforeUnmount, onMounted, ref } from 'vue'

const root = ref()
const ossLane = ref()
const managedLane = ref()
const questionsNode = ref()
const fileNode = ref()
const filesNode = ref()
const modulesNode = ref()
const providerNode = ref()
const tofuNode = ref()
const stateNode = ref()
const nadramaNode = ref()
const workerNode = ref()
const svgSize = ref({ width: 0, height: 0 })
const lines = ref([])
const labelStyle = ref({ display: 'none' })

// Box edges in layout pixels relative to the diagram, so connectors stay correct under
// Slidev's slide scaling. offsetTop is measured from the parent's padding edge, so add
// each positioned ancestor's border too.
function box(el) {
  let top = 0
  let left = 0
  for (let node = el; node && node !== root.value; node = node.offsetParent) {
    top += node.offsetTop
    left += node.offsetLeft
    if (node.offsetParent && node.offsetParent !== root.value) {
      top += node.offsetParent.clientTop
      left += node.offsetParent.clientLeft
    }
  }
  const width = el.offsetWidth
  const height = el.offsetHeight
  return { top, left, right: left + width, bottom: top + height, cx: left + width / 2, cy: top + height / 2 }
}

// Arrowhead whose tip touches (x, y), pointing in direction dir.
function head(x, y, dir) {
  const l = 9
  const w = 6
  const pts = {
    up: [[x - w, y + l], [x + w, y + l]],
    down: [[x - w, y - l], [x + w, y - l]],
    right: [[x - l, y - w], [x - l, y + w]],
  }[dir]
  return `${pts[0].join(',')} ${pts[1].join(',')} ${x},${y}`
}

function placeConnectors() {
  // Slidev mounts upcoming slides while hidden; measure only once laid out.
  if (!root.value.offsetWidth) return
  const q = box(questionsNode.value)
  const file = box(fileNode.value)
  const files = box(filesNode.value)
  const mods = box(modulesNode.value)
  const provider = box(providerNode.value)
  const tofu = box(tofuNode.value)
  const state = box(stateNode.value)
  const nadrama = box(nadramaNode.value)
  const worker = box(workerNode.value)
  const oss = box(ossLane.value)
  const managed = box(managedLane.value)
  // The worker pool's connector turns halfway between the two lanes.
  const midY = (oss.bottom + managed.top) / 2
  // Elbow arms into the config file's sides are at least `arm` long, while still leaving
  // the vertical leg inside the box it starts or ends at.
  const arm = 30
  const qx = Math.max(Math.min(q.cx, file.left - arm), q.left + 20)
  const fx = Math.min(Math.max(files.cx, file.right + arm), files.right - 20)
  // Stop each shaft at the base of its arrowhead so the line doesn't poke through the tip.
  lines.value = [
    // Questions: down, then right into the config file's left side.
    { path: `M ${qx} ${q.bottom} V ${file.cy} H ${file.left - 9}`, head: head(file.left, file.cy, 'right') },
    // Config file: out of its right side, then up into the OpenTofu files.
    { path: `M ${file.right} ${file.cy} H ${fx} V ${files.bottom + 9}`, head: head(fx, files.bottom, 'up') },
    { path: `M ${files.right} ${files.cy} H ${tofu.left - 9}`, head: head(tofu.left, files.cy, 'right') },
    // Inputs OpenTofu consumes: plain lines, no arrowheads.
    { path: `M ${mods.cx} ${mods.bottom} V ${tofu.top}` },
    { path: `M ${provider.cx} ${provider.bottom} V ${tofu.top}` },
    { path: `M ${tofu.cx} ${tofu.bottom} V ${state.top - 9}`, head: head(tofu.cx, state.top, 'down') },
    { path: `M ${nadrama.right} ${nadrama.cy} H ${worker.left - 9}`, head: head(worker.left, nadrama.cy, 'right') },
    // Worker pool: up, across the gap between the lanes, then up into the config file.
    { path: `M ${worker.cx} ${worker.top} V ${midY} H ${file.cx} V ${file.bottom + 9}`, head: head(file.cx, file.bottom, 'up') },
  ]
  svgSize.value = { width: root.value.offsetWidth, height: root.value.offsetHeight }
  labelStyle.value = { left: `${worker.cx + 10}px`, top: `${midY}px` }
}

// Re-measure whenever the diagram's size changes, including when its slide becomes visible.
let observer
onMounted(async () => {
  observer = new ResizeObserver(placeConnectors)
  observer.observe(root.value)
  // Style edits in dev can move boxes without resizing the diagram.
  import.meta.hot?.on('vite:afterUpdate', () => requestAnimationFrame(placeConnectors))
  await document.fonts.ready
  placeConnectors()
})
onBeforeUnmount(() => observer?.disconnect())
</script>

<style scoped>
.execution-path {
  display: grid;
  margin-top: 10px;
  position: relative;
}

/* Both lanes share columns, so the worker pool sits directly under the config file. */
.lane {
  align-items: center;
  border: 1.5px dashed #9fb0c8;
  border-radius: 14px;
  column-gap: 34px;
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(0, 1fr) minmax(0, 1.3fr);
  padding: 14px 18px 10px;
  position: relative;
}

.lane-oss {
  border: 2px solid var(--podplane-blue);
  grid-template-areas:
    ".    .    mods"
    "q    cli  tofu"
    "file file state";
  row-gap: 24px;
}

.lane-managed {
  grid-template-areas: "nadrama worker note";
}

.lane-label {
  background: #fff;
  color: var(--podplane-blue);
  font-size: 13px;
  font-weight: 800;
  left: 16px;
  letter-spacing: 0.1em;
  padding: 0 6px;
  position: absolute;
  text-transform: uppercase;
  top: -10px;
}

.lane-label-end {
  left: auto;
  right: 16px;
}

.lane-managed .lane-label {
  color: var(--podplane-muted);
}

.node {
  align-items: center;
  background: var(--podplane-surface);
  border: 1px solid #d7deea;
  border-radius: 10px;
  display: flex;
  flex-direction: column;
  font-size: 17px;
  font-weight: 700;
  gap: 2px;
  justify-content: center;
  padding: 8px 10px;
  text-align: center;
}

/* Compact boxes: icon beside the text rather than above it. */
.node-row {
  flex-direction: row;
  gap: 12px;
}

.node-row span {
  display: flex;
  flex-direction: column;
  text-align: left;
}

.node-row svg {
  flex: 0 0 auto;
  font-size: 26px;
}

.node svg {
  color: var(--podplane-blue);
  font-size: 22px;
}

.node small {
  color: var(--podplane-muted);
  font-size: 14px;
  font-weight: 500;
  line-height: 1.3;
}

.node-questions { grid-area: q; }

/* The middle row's three boxes share one height. */
.node-questions,
.node-cli,
.node-tofu {
  align-self: stretch;
}
.node-file { grid-area: file; }
.node-cli { grid-area: cli; }
.node-tofu { grid-area: tofu; }
.node-worker { grid-area: worker; }
.node-nadrama { grid-area: nadrama; }

.node-file {
  justify-self: center;
  padding-inline: 16px;
}

.node-file small {
  font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
}

/* The config file and state bucket share a bottom edge. They sit 12px under the
   middle row, like the inputs above OpenTofu, leaving room below for the worker pool's arrowhead. */
.node-file,
.output {
  align-self: end;
  margin-block: -12px 12px;
}

.node-cli {
  background: var(--podplane-blue);
  border: 0;
  box-shadow: 0 8px 20px rgb(0 102 255 / 24%);
  color: #fff;
}

.node-cli strong,
.node-tofu strong,
.node-worker strong {
  font-size: 21px;
}

/* Tighter spacing so its two-line description fits the OpenTofu box's height. */
.node-cli {
  gap: 0;
  padding-block: 6px;
}

.node-cli strong {
  line-height: 1.1;
}

.node-cli small {
  line-height: 1.2;
}

.node-cli small,
.node-tofu small {
  color: rgb(255 255 255 / 85%);
}

.node-tofu {
  background: var(--podplane-ink);
  border: 0;
  color: #fff;
}

/* Inputs OpenTofu consumes, above it; the state it writes, below it. */
.inputs {
  display: grid;
  gap: 8px;
  grid-area: mods;
  grid-template-columns: 1fr 1fr;
  /* Halve the row gap above OpenTofu; the modules and provider attach to it directly. */
  margin-bottom: -12px;
}

.inputs div,
.output {
  align-items: center;
  background: #fff;
  border: 1.5px solid #d7deea;
  border-radius: 8px;
  display: flex;
  font-size: 15px;
  font-weight: 600;
  gap: 8px;
  line-height: 1.25;
  padding: 7px 10px;
}

.output {
  grid-area: state;
  justify-content: center;
}

.inputs svg,
.output svg {
  color: var(--podplane-blue);
  flex: 0 0 auto;
  font-size: 18px;
}

/* Spacer between the lanes; the connector and its label are drawn over it. */
.runs-cli {
  height: 40px;
}

.connectors {
  left: 0;
  overflow: visible;
  pointer-events: none;
  position: absolute;
  top: 0;
  z-index: 1;
}

.connectors path {
  fill: none;
  stroke: var(--podplane-blue);
  stroke-linejoin: round;
  stroke-width: 2;
}

.connectors polygon {
  fill: var(--podplane-blue);
}

.runs-label {
  color: var(--podplane-blue);
  font-size: 15px;
  font-weight: 700;
  line-height: 1;
  position: absolute;
  transform: translateY(-50%);
  white-space: nowrap;
}

.managed-note {
  color: var(--podplane-muted);
  font-size: 17px;
  grid-area: note;
  line-height: 1.4;
  text-align: center;
}
</style>
