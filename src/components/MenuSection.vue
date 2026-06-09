<script setup>
const menuItems = [
  {
    category: "前菜",
    name: "烤甜菜根与山羊奶酪",
    description: "柑橘油醋、榛子碎、莳萝与脆面包片。",
    price: "¥68",
  },
  {
    category: "主菜",
    name: "炭火慢烤牛小排",
    description: "黑蒜汁、时令根茎蔬菜、烟熏海盐。",
    price: "¥188",
    featured: true,
  },
  {
    category: "甜点",
    name: "桂花焦糖布丁",
    description: "薄脆糖壳、乌龙奶油、腌渍梨丁。",
    price: "¥52",
  },
];
</script>

<template>
  <section id="menu" class="menu-section">
    <div class="section-heading">
      <p class="eyebrow">Highlights</p>
      <h2>推荐菜品</h2>
    </div>
    <div class="menu-grid">
      <article
        v-for="item in menuItems"
        :key="item.name"
        class="menu-card"
        :class="{ 'featured-card': item.featured }"
      >
        <div>
          <span class="tag">{{ item.category }}</span>
          <h3>{{ item.name }}</h3>
        </div>
        <p>{{ item.description }}</p>
        <strong>{{ item.price }}</strong>
      </article>
    </div>
  </section>
</template>
