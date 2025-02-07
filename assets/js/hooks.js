import Chart from 'chart.js/auto'

const Hooks = {};

Hooks.Chart = {

    dataset() { return JSON.parse(this.el.dataset.incomes); },
  mounted() {
    // Get the canvas context
    const ctx = this.el.getContext("2d");

    // Initialize the Chart
    this.chart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: ['Jan', 'Feb', 'March', 'April', 'May', 'June'],
        datasets: [{
          label: '# of Incomes',
          data: this.dataset(),
          borderWidth: 1,
          borderColor: '#000',
          backgroundColor: '#000',
        }]
      },
      options: {
        scales: {
          y: {
            beginAtZero: true
          }
        },
        tooltip: {
            enabled: true
          }
      }
    });

    console.log("Chart initialized");
  },
  destroyed() {
    // Clean up the chart instance
    if (this.chart) {
      this.chart.destroy();
    }
  }
};

export default Hooks;
