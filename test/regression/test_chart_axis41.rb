# -*- coding: utf-8 -*-

require 'helper'

class TestRegressionChartAxis41 < Minitest::Test
  def setup
    setup_dir_var
  end

  def teardown
    @tempfile.close(true)
  end

  def test_chart_axis41
    @xlsx = 'chart_axis41.xlsx'
    workbook    = WriteXLSX.new(@io)
    worksheet   = workbook.add_worksheet
    chart       = workbook.add_chart(:type => 'column', :embedded => 1)

    # For testing, copy the randomly generated axis ids in the target xlsx file.
    chart.instance_variable_set(:@axis_ids, [108321024, 108328448])

    data = [
      [1, 2, 3, 4,  5],
      [2, 4, 6, 8,  10],
      [3, 6, 9, 12, 15]
    ]

    worksheet.write('A1', data)

    chart.add_series(:values => '=Sheet1!$A$1:$A$5')
    chart.add_series(:values => '=Sheet1!$B$1:$B$5')
    chart.add_series(:values => '=Sheet1!$C$1:$C$5')

    chart.set_x_axis(
      :major_tick_mark => 'none',
      :minor_tick_mark => 'inside'
    )
    chart.set_y_axis(:minor_tick_mark => 'cross')

    worksheet.insert_chart('E9', chart)

    workbook.close
    compare_for_regression(
      nil,
      { 'xl/charts/chart1.xml' => ['<c:pageMargins'] }
    )
  end
end
