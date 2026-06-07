<script setup>
import { reactive, ref } from "vue";

const partyOptions = ["2 位", "3 位", "4 位", "5-6 位"];
const timeOptions = ["18:00", "18:30", "19:00", "19:30", "20:00"];

const form = reactive({
  name: "",
  party: partyOptions[0],
  time: timeOptions[0],
  requests: "",
});
const message = ref("");

function submitBooking() {
  const guestName = form.name.trim() || "您好";
  const requestNote = form.requests.trim() ? "，特殊要求也已记录" : "";
  message.value = `${guestName}，已收到 ${form.party} ${form.time} 的订位请求${requestNote}，我们会尽快电话确认。`;

  form.name = "";
  form.party = partyOptions[0];
  form.time = timeOptions[0];
  form.requests = "";
}
</script>

<template>
  <section id="booking" class="booking-band">
    <div class="booking-copy">
      <p class="eyebrow">Reservation</p>
      <h2>预留今晚的一张桌子</h2>
      <p>
        工作日适合两三好友小聚，周末建议提前一天预约。我们会为过敏、素食或纪念日需求预留备注。
      </p>
    </div>
    <form class="booking-form" aria-label="订位表单" @submit.prevent="submitBooking">
      <div class="booking-form-header">
        <div>
          <strong>预订信息</strong>
          <span>我们通常会在营业时间内尽快确认</span>
        </div>
        <span class="booking-status">可预订</span>
      </div>

      <label class="booking-field booking-field-name">
        <span class="field-label">姓名</span>
        <input
          v-model="form.name"
          type="text"
          name="name"
          autocomplete="name"
          placeholder="你的称呼"
        />
      </label>

      <label class="booking-field">
        <span class="field-label">人数</span>
        <select v-model="form.party" name="party">
          <option v-for="party in partyOptions" :key="party" :value="party">
            {{ party }}
          </option>
        </select>
      </label>

      <label class="booking-field">
        <span class="field-label">时间</span>
        <select v-model="form.time" name="time">
          <option v-for="time in timeOptions" :key="time" :value="time">
            {{ time }}
          </option>
        </select>
      </label>

      <label class="booking-field booking-field-wide">
        <span class="field-label">特殊要求</span>
        <textarea
          v-model="form.requests"
          name="requests"
          rows="3"
          maxlength="200"
          placeholder="过敏、素食、儿童座椅或纪念日等"
        ></textarea>
        <span class="field-hint">{{ form.requests.length }}/200</span>
      </label>

      <button class="booking-submit" type="submit">
        <span>发送预订</span>
        <span class="submit-arrow" aria-hidden="true">→</span>
      </button>
      <p class="form-message" role="status" aria-live="polite">{{ message }}</p>
    </form>
  </section>
</template>
