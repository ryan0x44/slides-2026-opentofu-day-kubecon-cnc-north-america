<script setup lang="ts">
import QrcodeVue from 'qrcode.vue'

defineProps<{
  value: string
  size?: number
  foreground?: string
  background?: string
}>()
</script>

<template>
  <div class="qr-frame">
    <QrcodeVue
      :value="value"
      :size="size ?? 250"
      :foreground="foreground ?? '#000'"
      :background="background ?? '#fff'"
      level="M"
      render-as="svg"
    />
  </div>
</template>
