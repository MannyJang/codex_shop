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
      <div class="multilingual-copy">
        <p lang="zh-CN">
          我们以小份分享菜、手工面包、炭烤主菜和低干预葡萄酒为主线。菜单每两周微调，
          让熟客每次来都能碰见一点新鲜。
        </p>
        <p lang="en">
          Small sharing plates, house-baked bread, charcoal-grilled mains, and
          low-intervention wines shape our menu. We make subtle changes every two weeks,
          so returning guests can always discover something new.
        </p>
        <p lang="ko">
          작은 공유 요리와 수제 빵, 숯불 메인 요리, 저개입 와인을 중심으로 메뉴를
          구성합니다. 2주마다 메뉴를 조금씩 다듬어, 다시 찾는 손님도 늘 새로운 맛을 만날
          수 있습니다.
        </p>
      </div>
      <dl class="stats" aria-label="餐厅特色">
        <div v-for="stat in stats" :key="stat.label">
          <dt>{{ stat.value }}</dt>
          <dd>{{ stat.label }}</dd>
        </div>
      </dl>
    </div>
  </section>
</template>
