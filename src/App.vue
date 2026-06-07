<script setup>
import AboutSection from "./components/AboutSection.vue";
import BookingSection from "./components/BookingSection.vue";
import HeroSection from "./components/HeroSection.vue";
import MenuSection from "./components/MenuSection.vue";
import SiteFooter from "./components/SiteFooter.vue";
import SiteHeader from "./components/SiteHeader.vue";
import VisitSection from "./components/VisitSection.vue";
</script>

<template>
  <SiteHeader />
  <main id="top">
    <HeroSection />
    <AboutSection />
    <MenuSection />
    <BookingSection />
    <VisitSection />
  </main>
  <SiteFooter />
</template>
