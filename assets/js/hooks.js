import Chart from 'chart.js/auto'
import live_select from "live_select"

const Hooks = {
  Chart: {
    dataset() {
      return JSON.parse(this.el.dataset.incomes);
    },
    mounted() {
      // Get the canvas context
      const ctx = this.el.getContext("2d");

      // Initialize the Chart
      this.chart = new Chart(ctx, {
        type: "bar",
        data: {
          labels: ["Jan", "Feb", "March", "April", "May", "June"],
          datasets: [
            {
              label: "# of Incomes",
              data: this.dataset(),
              borderWidth: 1,
              backgroundColor: [
                '#6359E9',
                '#64CFF6',
                '#EFF4FB'
              ],
            },
          ],
        },
        options: {
          scales: {
            y: {
              beginAtZero: true,
            },
          },
          tooltip: {
            enabled: true,
          },
        },
      });

      console.log("Chart initialized");
    },
    destroyed() {
      // Clean up the chart instance
      if (this.chart) {
        this.chart.destroy();
      }
    },
  },

  DoughnutChart: {
    dataset() {
      return JSON.parse(this.el.dataset.incomes);
    },
    mounted() {
      // Get the canvas context
      const ctx = this.el.getContext("2d");

      // Initialize the Chart
      this.chart = new Chart(ctx, {
        type: "doughnut",
        options: {
          responsive: true,
          maintainAspectRatio: false,
        },
        data: {
          datasets: [
            {
              label: "# of Incomes",
              data: this.dataset(),
              borderWidth: 1,
              backgroundColor: [
                '#6359E9',
                '#64CFF6',
                '#EFF4FB'
              ],
              hoverOffset: 4,
            },
          ],
        },
        options: {
          scales: {
            y: {
              beginAtZero: true,
            },
          },
          tooltip: {
            enabled: true,
          },
        },
      });

      console.log("Chart initialized");
    },
    destroyed() {
      // Clean up the chart instance
      if (this.chart) {
        this.chart.destroy();
      }
    },
  },
  ...live_select
};

export default Hooks;


