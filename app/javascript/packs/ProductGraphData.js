import React from 'react';
import {XYPlot, XAxis, YAxis, HorizontalGridLines, VerticalBarSeries, 
DiscreteColorLegend} from 'react-vis';
import { Page, Card, Select, Button, TextField, Stack, FormLayout, DisplayText,
Thumbnail, ResourceList, Pagination, Layout, Checkbox } from '@shopify/polaris';

export default class ProductGraphData extends React.Component {
  render() {
    const price_test_data = this.props.price_test_data;
    const price_points = price_test_data.price_points
    const variant_plot_data = this.props.variant_plot_data
    return (<XYPlot
              xType='ordinal'
              width={window.innerWidth - 50}
              height={500} 
              margin={{left: 50}}>
              <HorizontalGridLines />
              <VerticalBarSeries data =  {variant_plot_data} />
              <XAxis />
              <YAxis />
            </XYPlot>
    );
  }
}


