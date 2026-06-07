<script setup>
const stats = [
  { value: "24", label: "席小餐厅" },
  { value: "2周", label: "菜单更新" },
  { value: "6道", label: "晚间套餐" },
];
</script>

<template>
  <section id="story" class="intro band">
    <div class="section-heading">
      <p class="eyebrow">About</p>
      <h2>모든 만남을 위해 따뜻한 불빛을 남겨둡니다</h2>
    </div>
    <div class="intro-copy">
      <p>
        我们以小份分享菜、手工面包、炭烤主菜和低干预葡萄酒为主线。菜单每两周微调，
        让熟客每次来都能碰见一点新鲜。
      </p>
      <dl class="stats" aria-label="餐厅特色">
        <div v-for="stat in stats" :key="stat.label">
          <dt>{{ stat.value }}</dt>
          <dd>{{ stat.label }}</dd>
        </div>
      </dl>
    </div>
  </section>
</template>
