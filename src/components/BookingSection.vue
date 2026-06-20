<script setup>
import { reactive, ref } from "vue";
import { isSupabaseConfigured, supabase } from "../lib/supabase";

const partyOptions = ["2 位", "3 位", "4 位", "5-6 位"];
const timeOptions = ["18:00", "18:30", "19:00", "19:30", "20:00"];

const form = reactive({
  name: "",
  phone: "",
  party: partyOptions[0],
  time: timeOptions[0],
  requests: "",
});
const message = ref("");
const messageType = ref("");
const isSubmitting = ref(false);

async function submitBooking() {
  message.value = "";
  messageType.value = "";

  if (!isSupabaseConfigured) {
    messageType.value = "error";
    message.value = "预约服务尚未配置，请稍后再试。";
    return;
  }

  isSubmitting.value = true;

  const guestName = form.name.trim();
  const requestNote = form.requests.trim();
  const { error } = await supabase.from("reservation").insert({
    guest_name: guestName,
    phone: form.phone.trim(),
    party_size: form.party,
    reservation_time: form.time,
    special_requests: requestNote,
  });

  isSubmitting.value = false;

  if (error) {
    console.error("Failed to save reservation:", error.message);
    messageType.value = "error";
    message.value = "提交失败，请检查网络后重试，或致电餐厅预约。";
    return;
  }

  messageType.value = "success";
  message.value = `${guestName}，已收到 ${form.party} ${form.time} 的订位请求，我们会尽快电话确认。`;

  form.name = "";
  form.phone = "";
  form.party = partyOptions[0];
  form.time = timeOptions[0];
  form.requests = "";
}
</script>

<template>
  <section id="booking" class="booking-band">
    <div class="booking-copy">
      <p class="eyebrow">Reservation</p>
      <h2 class="multilingual-heading">
        <span lang="zh-CN">预留今晚的一张桌子</span>
        <span lang="en">Reserve a table for tonight</span>
        <span lang="ko">오늘 저녁을 위한 테이블을 예약하세요</span>
      </h2>
      <div class="multilingual-copy">
        <p lang="zh-CN">
          工作日适合两三好友小聚，周末建议提前一天预约。我们会为过敏、素食或纪念日需求预留备注。
        </p>
        <p lang="en">
          Weekdays are perfect for a small gathering of two or three, while weekend
          reservations are best made a day ahead. Let us know about allergies, vegetarian
          preferences, or special occasions.
        </p>
        <p lang="ko">
          평일에는 두세 분의 편안한 모임에 잘 어울리며, 주말에는 하루 전 예약을
          권합니다. 알레르기, 채식 또는 기념일 요청 사항도 미리 남겨 주세요.
        </p>
      </div>
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
          maxlength="80"
          required
        />
      </label>

      <label class="booking-field booking-field-wide">
        <span class="field-label">手机号</span>
        <input
          v-model="form.phone"
          type="tel"
          name="phone"
          autocomplete="tel"
          placeholder="用于确认预约"
          minlength="6"
          maxlength="30"
          required
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

      <button class="booking-submit" type="submit" :disabled="isSubmitting">
        <span>{{ isSubmitting ? "正在提交…" : "发送预订" }}</span>
        <span class="submit-arrow" aria-hidden="true">→</span>
      </button>
      <p
        class="form-message"
        :class="{ 'form-message-error': messageType === 'error' }"
        role="status"
        aria-live="polite"
      >
        {{ message }}
      </p>
    </form>
  </section>
</template>
