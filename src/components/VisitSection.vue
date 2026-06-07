<script setup>
const visitItems = [
  {
    title: "地址",
    lines: ["上海市静安区梧桐路 18 号 1 层"],
  },
  {
    title: "营业时间",
    lines: ["周二至周日 17:30 - 22:30", "周一店休"],
  },
  {
    title: "联系",
    lines: ["+86 138 0000 8888", "hello@shiwaiting.example"],
    phone: true,
  },
];
</script>

<template>
  <section id="visit" class="visit-section">
    <div class="section-heading">
      <p class="eyebrow">Visit</p>
      <h2>到店信息</h2>
    </div>
    <div class="visit-grid">
      <div v-for="item in visitItems" :key="item.title">
        <h3>{{ item.title }}</h3>
        <p>
          <template v-for="(line, index) in item.lines" :key="line">
            <a v-if="item.phone && index === 0" href="tel:+8613800008888">{{ line }}</a>
            <template v-else>{{ line }}</template>
            <br v-if="index < item.lines.length - 1" />
          </template>
        </p>
      </div>
    </div>
  </section>
</template>
