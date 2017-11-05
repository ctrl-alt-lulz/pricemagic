import React from 'react';
import {XYPlot, XAxis, YAxis, HorizontalGridLines, VerticalBarSeries, 
DiscreteColorLegend} from 'react-vis';
import { Page, Card, Select, Button, TextField, Stack, FormLayout, DisplayText,
Thumbnail, ResourceList, Pagination, Layout, Checkbox } from '@shopify/polaris';

export default class ProductGraphData extends React.Component {
  render() {
    const variant_plot_data = this.props.variant_plot_data
    const revenue_hash = this.props.revenue_hash
    const profit_hash = this.props.profit_hash
    const button_states = this.props.button_states
    const rev_plot = button_states['revenue']
    const profit_plot = button_states['profit']
    const rev_per_view_plot = button_states['rev_per_view']
    const profit_per_view_plot = button_states['profit_per_view']
    
    return (<XYPlot
              xType='ordinal'
              width={window.innerWidth - 50}
              height={500} 
              margin={{left: 50}}>
              <HorizontalGridLines />
              { (rev_plot) ? <VerticalBarSeries data = {this.props.revenue_hash} /> : null }
              { (profit_plot) ? <VerticalBarSeries data = {this.props.profit_hash} /> : null }
              { (rev_per_view_plot) ? <VerticalBarSeries data = {this.props.revenue_per_view_hash} /> : null }
              { (profit_per_view_plot) ? <VerticalBarSeries data = {this.props.profit_per_view_hash} /> : null }
              <XAxis title="X"/>
              <YAxis title="Y"/>
            </XYPlot>
    );
  }
}


// add other plots as vertical bar series
// pass in hash of plots, create vertical bar series for each plot

