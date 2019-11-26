'use strict'

const tableControls = {

  selectAll: () => {
    $('.dt-buttons .dt-button').eq(0).trigger('click')
  },

  deselectAll: () => {
    $('.dt-buttons .dt-button').eq(1).trigger('click')
  },

  deleteSelected: () => {
    $('.dt-buttons .dt-button').eq(2).trigger('click')
  },

  editColumns: () => {
    $('.datatables tr td').last().trigger('click')
  }

}

module.exports = tableControls
