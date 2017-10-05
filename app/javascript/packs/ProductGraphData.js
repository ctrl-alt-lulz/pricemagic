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
    const google_analytics_data = this.props.google_analytics_data;
    console.log(price_test_data)
    console.log(google_analytics_data)
    return (<div>
            <XYPlot
              xType={'ordinal'}
              width={1800}
              height={300}>
              <HorizontalGridLines />
              <VerticalBarSeries
                data={[
                      {x: 'A', y: 10},
                      {x: 'B', y: 5},
                      {x: 'C', y: 15}
                    ]}
                
                />
              <XAxis />
              <YAxis />
            </XYPlot>
            </div>
    );
  }
}


