<script setup>
import { computed, onBeforeUnmount, onMounted, ref } from "vue";
import { isSupabaseConfigured, supabase } from "./lib/supabase";

const statusOptions = ["pending", "confirmed", "cancelled"];
const statusLabels = {
  pending: "待确认",
  confirmed: "已确认",
  cancelled: "已取消",
};

const session = ref(null);
const email = ref("");
const password = ref("");
const selectedDate = ref(new Intl.DateTimeFormat("en-CA", { timeZone: "Asia/Seoul" }).format(new Date()));
const reservations = ref([]);
const authError = ref("");
const dataError = ref("");
const isAuthenticating = ref(false);
const isLoading = ref(false);
const updatingId = ref("");
let authSubscription;

const isLoggedIn = computed(() => Boolean(session.value));

function formatTime(time) {
  return time?.slice(0, 5) || "—";
}

async function loadReservations() {
  if (!session.value || !isSupabaseConfigured) return;

  isLoading.value = true;
  dataError.value = "";

  let query = supabase
    .from("reservation")
    .select(
      "id, guest_name, phone, party_size, reservation_date, reservation_time, special_requests, status, created_at",
    )
    .order("reservation_time", { ascending: true });

  if (selectedDate.value) {
    query = query.eq("reservation_date", selectedDate.value);
  }

  const { data, error } = await query;
  isLoading.value = false;

  if (error) {
    reservations.value = [];
    dataError.value =
      error.code === "42501"
        ? "此账号没有后台权限，请联系项目管理员。"
        : "预约记录加载失败，请稍后重试。";
    return;
  }

  reservations.value = data;
}

async function signIn() {
  authError.value = "";
  isAuthenticating.value = true;

  const { error } = await supabase.auth.signInWithPassword({
    email: email.value.trim(),
    password: password.value,
  });

  isAuthenticating.value = false;

  if (error) {
    authError.value = "邮箱或密码不正确。";
    return;
  }

  password.value = "";
}

async function signOut() {
  await supabase.auth.signOut();
  reservations.value = [];
  dataError.value = "";
}

async function updateStatus(reservation, status) {
  if (reservation.status === status) return;

  updatingId.value = reservation.id;
  dataError.value = "";

  const { data, error } = await supabase
    .from("reservation")
    .update({ status })
    .eq("id", reservation.id)
    .select("id, status")
    .single();

  updatingId.value = "";

  if (error) {
    dataError.value = "状态更新失败，请重试。";
    return;
  }

  reservation.status = data.status;
}

onMounted(async () => {
  document.title = "预约管理 | 拾味庭";

  if (!isSupabaseConfigured) return;

  const { data } = await supabase.auth.getSession();
  session.value = data.session;

  const { data: listener } = supabase.auth.onAuthStateChange((_event, nextSession) => {
    session.value = nextSession;
    if (nextSession) {
      setTimeout(loadReservations, 0);
    }
  });

  authSubscription = listener.subscription;

  if (session.value) {
    await loadReservations();
  }
});

onBeforeUnmount(() => {
  authSubscription?.unsubscribe();
});
</script>

<template>
  <main class="admin-page">
    <header class="admin-header">
      <a class="admin-brand" href="/">
        <span class="brand-mark">拾</span>
        <span>拾味庭</span>
      </a>
      <div class="admin-header-copy">
        <p class="eyebrow">Reservation Desk</p>
        <h1>预约管理</h1>
      </div>
      <button v-if="isLoggedIn" class="admin-ghost-button" type="button" @click="signOut">
        退出登录
      </button>
      <a v-else class="admin-ghost-button" href="/">返回网站</a>
    </header>

    <section v-if="!isSupabaseConfigured" class="admin-state-card">
      <p class="eyebrow">Configuration</p>
      <h2>后台服务尚未配置</h2>
      <p>请先配置 Supabase 环境变量。</p>
    </section>

    <section v-else-if="!isLoggedIn" class="admin-login-shell">
      <div class="admin-login-copy">
        <p class="eyebrow">Owner Access</p>
        <h2>欢迎回来</h2>
        <p>登录后可查看预约、按日期筛选，并更新确认状态。</p>
      </div>
      <form class="admin-login-form" @submit.prevent="signIn">
        <label>
          <span>邮箱</span>
          <input v-model="email" type="email" autocomplete="username" required />
        </label>
        <label>
          <span>密码</span>
          <input
            v-model="password"
            type="password"
            autocomplete="current-password"
            minlength="8"
            required
          />
        </label>
        <button class="admin-primary-button" type="submit" :disabled="isAuthenticating">
          {{ isAuthenticating ? "正在登录…" : "进入后台" }}
        </button>
        <p v-if="authError" class="admin-error" role="alert">{{ authError }}</p>
      </form>
    </section>

    <section v-else class="admin-dashboard">
      <div class="admin-toolbar">
        <div>
          <p class="eyebrow">Daily Bookings</p>
          <h2>{{ selectedDate || "全部预约" }}</h2>
        </div>
        <label class="admin-date-filter">
          <span>按日期筛选</span>
          <input v-model="selectedDate" type="date" @change="loadReservations" />
        </label>
      </div>

      <p v-if="dataError" class="admin-error admin-data-error" role="alert">{{ dataError }}</p>

      <div v-if="isLoading" class="admin-state-card">正在读取预约记录…</div>
      <div v-else-if="!reservations.length && !dataError" class="admin-state-card">
        <p class="eyebrow">All Clear</p>
        <h3>这一天还没有预约</h3>
      </div>

      <div v-else-if="reservations.length" class="admin-table-wrap">
        <table class="admin-table">
          <thead>
            <tr>
              <th>时间</th>
              <th>姓名</th>
              <th>手机号</th>
              <th>人数</th>
              <th>备注</th>
              <th>状态</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="reservation in reservations" :key="reservation.id">
              <td data-label="时间">
                <strong>{{ formatTime(reservation.reservation_time) }}</strong>
              </td>
              <td data-label="姓名">{{ reservation.guest_name }}</td>
              <td data-label="手机号">
                <a :href="`tel:${reservation.phone}`">{{ reservation.phone }}</a>
              </td>
              <td data-label="人数">{{ reservation.party_size }}</td>
              <td data-label="备注" class="admin-note">
                {{ reservation.special_requests || "无" }}
              </td>
              <td data-label="状态">
                <select
                  class="admin-status-select"
                  :class="`status-${reservation.status}`"
                  :value="reservation.status"
                  :disabled="updatingId === reservation.id"
                  :aria-label="`${reservation.guest_name}的预约状态`"
                  @change="updateStatus(reservation, $event.target.value)"
                >
                  <option v-for="status in statusOptions" :key="status" :value="status">
                    {{ statusLabels[status] }}
                  </option>
                </select>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>
  </main>
</template>
