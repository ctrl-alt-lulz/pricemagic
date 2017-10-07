import React from 'react';
import {XYPlot, XAxis, YAxis, HorizontalGridLines, VerticalBarSeries} from 'react-vis';

export default class ProductGraphData extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
    };
  }

  render() {
    const price_test_data = this.props.price_test_data;
    const price_points = price_test_data.price_points
    // console.log(price_points)
    // console.log(price_test_data)
    console.log(price_test_data.final_plot)
    function getPricePoints (array) {
      return array.price_points
    }
    function plot_bar_graph(graph) {
      return(<VerticalBarSeries
                data =  {graph.map(extract_each_graph)}
            />);
    }
    function extract_each_graph(single_graph) {
      return single_graph
    }
    return (<div>
            <XYPlot
              xType={'ordinal'}
              width={window.innerWidth - 50}
              height={500}>
              <HorizontalGridLines />
              {price_test_data.final_plot.map(plot_bar_graph)}
              <XAxis />
              <YAxis />
            </XYPlot>
            </div>
    );
  }
}


