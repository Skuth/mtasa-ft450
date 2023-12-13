const ftParams = {
  rpm: 0,
  maxRpm: 6000,
  gear: 0,
  speed: 0,
  engineState: true,
  engineTemp: 0,
  oilPress: 0
}

const getRandomInRange = (min, max) => {
  return Number(Math.random() * (max - min + 1) + min).toFixed(2)
}

const updateFtParams = (rpm, gear, speed, engineState) => {
  ftParams.rpm = rpm
  ftParams.gear = gear
  ftParams.speed = speed
  ftParams.engineState = Boolean(engineState)
  ftParams.engineTemp = getRandomInRange(75, 83)
  ftParams.oilPress = getRandomInRange(2, 3)
}

Vue.component("rpm", {
  props: {
    rpm: {
      type: [Number, String],
      default: 0
    },
    maxRpm: {
      type: Number,
      default: 8000
    }
  },
  computed: {
    currentRpm() {
      return Number(this.rpm) || 0
    },
  },
  methods: {
    getRpmBarSize() {
      const barPercentage = (100 / this.maxRpm) * this.currentRpm
      const barLeftPercentage = 100 - barPercentage
      const barWidthPercentage = barLeftPercentage < 0 ? 0 : barLeftPercentage

      return `${barWidthPercentage}%`
    }
  },
  template: `
    <div class="rpm">
      <div class="rpm__text">
        <p>{{ currentRpm }}</p>
        <span>RPM</span>
      </div>

      <div class="rpm__bar">
        <div class="rpm__bar__container">
          <div
            class="rpm__bar__content"
            :style="{ width: getRpmBarSize() }"
          ></div>
        </div>
      </div>
    </div>
  `
})

Vue.component("status-item", {
  props: {
    title: {
      type: String,
      required: true
    },
    value: {
      type: [String, Number, Boolean],
      default: 0
    },
    isButton: {
      type: Boolean,
      default: false
    }
  },
  template: `
    <div class="status__item">
      <p class="status__item--title">
        {{ title }}
      </p>

      <p class="status__item--value" v-if="!isButton">
        {{ value }}
      </p>

      <p class="status__item--button" :class="value ? 'on' : 'off'" v-else></p>
    </div>
  `
})

Vue.component("status", {
  props: {
      status: {
        type: Object,
        default: () => ({
          gear: 0,
          speed: 0,
          engineState: false,
          engineTemp: 0,
          oilPress: 0
        })
      }
  },
  template: `
    <div class="status">
      <status-item title="Marcha" :value="status.gear || 'N'" />
      <status-item title="Velocidade" :value="status.speed" />
      <status-item title="Motor" :value="status.engineState" isButton />

      <status-item title="T. Motor" :value="status.engineTemp" />
      <status-item title="P. Óleo" :value="status.oilPress" />
    </div>
  `
})

Vue.component("shift-screen", {
  template: `
  <div class="shift">
    <div class="shift__container">
      <h1>SHIFT</h1>
    </div>
  </div>
  `
})

Vue.component("fueltech", {
  computed: {
    currentRpm() {
      return ftParams.rpm
    },
    maxRpm() {
      return ftParams.maxRpm
    },
    status() {
      return {
        gear: ftParams.gear,
        speed: ftParams.speed,
        engineState: ftParams.engineState,
        engineTemp: ftParams.engineTemp,
        oilPress: ftParams.oilPress
      }
    },
    isShiftScreenActive() {
      const rpmPercentage = (100 / this.maxRpm) * this.currentRpm

      if (rpmPercentage >= 95) {
        return true
      }

      return false
    }
  },
  template: `
    <div class="fueltech">
      <div class="fueltech__grid">
        <rpm :rpm="currentRpm" :maxRpm="maxRpm" />
        <status v-if="!isShiftScreenActive" :status="status" />
        <shift-screen v-else />
      </div>
    </div>
  `
})

let app = new Vue({
  el: "#app",
  data() {
    return {
      renderId: 0
    }
  },
  methods: {
    updateRender() {
      this.renderId += 1
    }
  }
})