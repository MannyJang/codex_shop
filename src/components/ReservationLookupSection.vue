<script setup>
import { reactive, ref } from "vue";
import { isSupabaseConfigured, supabase } from "../lib/supabase";

const statusLabels = {
  pending: "待确认",
  confirmed: "已确认",
  cancelled: "已取消",
};

const form = reactive({ phone: "" });
const reservations = ref([]);
const message = ref("");
const hasSearched = ref(false);
const isLoading = ref(false);

function formatDate(date) {
  return new Intl.DateTimeFormat("zh-CN", {
    year: "numeric",
    month: "long",
    day: "numeric",
  }).format(new Date(`${date}T00:00:00`));
}

function formatTime(time) {
  return time?.slice(0, 5) || "—";
}

async function lookupReservations() {
  message.value = "";
  reservations.value = [];
  hasSearched.value = false;

  if (!isSupabaseConfigured) {
    message.value = "查询服务尚未配置，请稍后再试。";
    return;
  }

  isLoading.value = true;

  const { data, error } = await supabase.rpc("lookup_reservations_by_phone", {
    lookup_phone: form.phone.trim(),
  });

  isLoading.value = false;
  hasSearched.value = true;

  if (error) {
    console.error("Failed to look up reservations:", error.message);
    message.value = "查询失败，请检查网络后重试。";
    return;
  }

  reservations.value = data;
}
</script>

<template>
  <section id="lookup" class="lookup-section">
    <div class="lookup-copy">
      <p class="eyebrow">Find Reservation</p>
      <h2>查询我的预约</h2>
      <p>
        输入预约时填写的完整手机号，即可查看预约日期、时间与当前确认状态。
      </p>
    </div>

    <div class="lookup-panel">
      <form class="lookup-form" @submit.prevent="lookupReservations">
        <label>
          <span>预约手机号</span>
          <input
            v-model="form.phone"
            type="tel"
            inputmode="tel"
            autocomplete="tel"
            minlength="6"
            maxlength="30"
            placeholder="请输入完整手机号"
            required
          />
        </label>
        <button type="submit" :disabled="isLoading">
          {{ isLoading ? "正在查询…" : "查询预约" }}
        </button>
      </form>
      <p class="lookup-privacy">仅支持完整手机号精确查询，不会显示姓名或手机号。</p>
      <p v-if="message" class="lookup-message" role="alert">{{ message }}</p>

      <div v-if="reservations.length" class="lookup-results" aria-live="polite">
        <article
          v-for="(reservation, index) in reservations"
          :key="`${reservation.reservation_date}-${reservation.reservation_time}-${index}`"
          class="lookup-card"
        >
          <div class="lookup-card-heading">
            <div>
              <span>{{ formatDate(reservation.reservation_date) }}</span>
              <strong>{{ formatTime(reservation.reservation_time) }}</strong>
            </div>
            <span class="lookup-status" :class="`status-${reservation.status}`">
              {{ statusLabels[reservation.status] || reservation.status }}
            </span>
          </div>
          <dl>
            <div>
              <dt>人数</dt>
              <dd>{{ reservation.party_size }}</dd>
            </div>
            <div>
              <dt>备注</dt>
              <dd>{{ reservation.special_requests || "无" }}</dd>
            </div>
          </dl>
        </article>
      </div>

      <div v-else-if="hasSearched && !message" class="lookup-empty" aria-live="polite">
        <strong>没有找到预约</strong>
        <span>请确认手机号与预约时填写的一致。</span>
      </div>
    </div>
  </section>
</template>
