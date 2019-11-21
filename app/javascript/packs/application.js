require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")
require("chartkick")
require("chart.js")
require("custom/notifications")

var turbolinksAnimate = require("turbolinks-animate")

// Custom
const components = require("custom/components")
const search = require("custom/search")
const clipboard = require("custom/click-to-copy")
const apps = require("custom/apps")
const appPopup = require("custom/app-popup")
const mobileSidebar = require("custom/mobile-sidebar")
const tableControls = require("custom/table-controls")
const tableColumns = require("custom/table-columns")
const paramPicker = require("custom/param-pickers")
const totalManager = require("custom/totals")
import Sortable from 'sortablejs'
import Tagify from '@yaireo/tagify'
import { CountUp } from 'countup.js'

$(document).on('turbolinks:load', () => {
  TurbolinksAnimate.init({ element: $('#animate-wrapper')[0], animation: 'fadein' })

  $('.statistic h3').each(function() {
    components.counter($(this).attr('id'), CountUp)
  })

  // Tagify
  if ($('.tagifier').length > 0) {
    $(document).find('.tagify__input').keydown(function(e) {
      const keycode = ((typeof e.keyCode !='undefined' && e.keyCode) ? e.keyCode : e.which)
      if (keycode === 9) {
        e.stopPropagation()
        e.preventDefault()
      }
    })
  }

  // Totals
  $(document).on('change', '#types_of_totals', function() { totalManager.changeType(this) })
  $(document).on('change', '#total-manager input', function() { totalManager.changeValue(this) })

  // New App
  $(document).on('change', '#new_select_an_app', function() { apps.newSelector(this) })

  // Campaigns
  $(document).on('click', '.card-select-app', function() { apps.select(this) })

  // Row Popup
  $(document).on('click', '#popup-nav a', function() { appPopup.tab(this) })

  // Mobile
  $(document).on('click', '#showSidebar', function(e) { mobileSidebar.show(e) })

  // Copy to clipboard
  $(document).on('click', '.click-to-copy', function() { clipboard.copy(this) })

  // App row data popup
  $(document).on('click', '.datatables tr td', function() { appPopup.show(this) })
  $(document).on('click', '#popup-wrapper', function() { appPopup.hide() })
  $(document).on('click', '#popup', function(e) { appPopup.popupClick(e) })

  // Table controls
  $(document).on('click', '#table-selectAll', function() { tableControls.selectAll() })
  $(document).on('click', '#table-deselectAll', function() { tableControls.deselectAll() })
  $(document).on('click', '#table-deleteSelected', function() { tableControls.deleteSelected() })

  // Search
  search.init()
  $(document).on('keydown', '#search', function(e) { search.search(e, this) })

  // Param pickers
  paramPicker.init()
  $(document).on('change', '#activity-date-picker', function() { paramPicker.dateChange(this) })
  $(document).on('change', '#table-show-amount', function() { paramPicker.perPageChange(this) })

  // Table columns
  tableColumns.init(Sortable, Tagify)
  $(document).on('click', '.table-row-info', function(e) { tableColumns.addColumnFromData(e, this) })
  $(document).on('click', '#close-table-column', function(e) { tableColumns.close(e) })
  $(document).on('click', '#add-table-column', function(e) { tableColumns.add(e) })
  $(document).on('click', '#update-table-column', function(e) { tableColumns.update(e, this, Sortable) })
  $(document).on('click', '.delete-column-badge', function(e) { tableColumns.delete(e, this) })
  $(document).on('keydown', '#table-column-key', function(e) { tableColumns.enterOnKey(e) })
  $(document).on('click', '#showAddColumn', function(e) { tableColumns.showAddColumn(Tagify) })
  $(document).on('click', '#saveTableColumns', function(e) { tableColumns.saveTableColumns() })
  $(document).on('click', '.table-column-badge', function(e) { tableColumns.editTableColumn(this, Tagify) })

})
