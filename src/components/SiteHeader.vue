<script setup>
const navItems = [
  { label: "菜单", href: "#menu" },
  { label: "理念", href: "#story" },
  { label: "订位", href: "#booking" },
  { label: "到店", href: "#visit" },
];
</script>

<template>
  <header class="site-header" aria-label="主导航">
    <a class="brand" href="#top" aria-label="拾味庭首页">
      <span class="brand-mark">拾</span>
      <span>拾味庭</span>
    </a>
    <nav class="nav-links" aria-label="页面导航">
      <a v-for="item in navItems" :key="item.href" :href="item.href">
        {{ item.label }}
      </a>
    </nav>
    <a class="header-action" href="tel:+8613800008888">致电</a>
  </header>
</template>
