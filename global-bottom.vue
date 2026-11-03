<template>
  <footer v-if="$slidev.nav.currentPage !== $slidev.nav.total" class="common-footer">
    <span>
      OpenTofu Day · KubeCon NA 2026 ·
      Building My Own IaC Engine Was a Mistake: Why I Now Use OpenTofu ·
      Ryan Djurovich ·
      <a href="https://ryan0x44.com">ryan0x44.com</a>
    </span>
    <span class="footer-meta">
      {{ $slidev.nav.currentPage }} of {{ $slidev.nav.total }}
    </span>
  </footer>
</template>
