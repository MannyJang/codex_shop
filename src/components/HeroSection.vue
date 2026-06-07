<script setup>
import heroImage from "../assets/restaurant-hero.png";
</script>

<template>
  <section class="hero" aria-label="餐厅首页首屏">
    <img
      class="hero-image"
      :src="heroImage"
      alt="温暖灯光下的现代餐厅与精致菜品"
    />
    <div class="hero-scrim" aria-hidden="true"></div>
    <div class="hero-content">
      <p class="eyebrow">Seasonal Table · Open Kitchen</p>
      <h1>拾味庭</h1>
      <p class="hero-copy">
        用当季食材、炭火香气和一间安静的开放厨房，做一顿适合慢慢聊天的晚餐。
      </p>
      <div class="hero-actions" aria-label="首页操作">
        <a class="button button-primary" href="#booking">预订座位</a>
        <a class="button button-secondary" href="#menu">查看菜单</a>
      </div>
    </div>
    <div class="hero-note" aria-label="营业状态">
      <span>今晚营业</span>
      <strong>17:30 - 22:30</strong>
    </div>
  </section>
</template>
