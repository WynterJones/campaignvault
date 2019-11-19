// import consumer from "./consumer"
// import { CountUp } from 'countup.js'
//
// consumer.subscriptions.create("RoomChannel", {
//   connected() {
//     console.log("Connected to the room!")
//   },
//
//   disconnected() {
//     console.log("Room disconnected.")
//   },
//
//   received(data) {
//     console.log("Recieving.")
//
//     if (data.type === 'dashboard' && location.pathname == "/") {
//       $('#dashboard-all-requests').text(data.total)
//       $('#dashboard-all-requests').parent().find('.badge').text(data.total)
//       const chart = Chartkick.charts["chart-1"]
//       chart.updateData(data.graph)
//       $('#activity-date-picker').val('?timeframe=30-days')
//     }
//
//     if (data.type === 'app' && location.pathname.includes(data.name)) {
//       let newRow = '<tr style="background: #fafafa;"><td class="table-selector select-checkbox"></td>'
//       const table_columns = JSON.parse(data.table_columns)
//       const jsonData = JSON.parse(data.rowJSON)
//       table_columns['keys'].forEach(function(value, index) {
//         value = value.replace('[[', '').replace(']]', '')
//         newRow += `<td>${jsonData[value.trim()]}</td>`
//       })
//       newRow += '</tr>'
//       $('.datatables tbody').prepend(newRow)
//       const chart = Chartkick.charts["chart-1"]
//       chart.updateData(data.graph)
//       $('#activity-date-picker').val('?timeframe=30-days')
//     }
//   }
// })
