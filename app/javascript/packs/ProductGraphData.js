import React from 'react';
import {XYPlot, XAxis, YAxis, HorizontalGridLines, VerticalBarSeries, 
DiscreteColorLegend} from 'react-vis';

export default class ProductGraphData extends React.Component {
  render() {
    const button_states = this.props.button_states
    const rev_plot = button_states['revenue']
    const profit_plot = button_states['profit']
    const rev_per_view_plot = button_states['rev_per_view']
    const profit_per_view_plot = button_states['profit_per_view']
    const plots = [
      {title: "Revenue", color: '#12939a' }, 
      {title: "Profit", color: '#79c7e3' },
      {title: "Revenue/View", color: '#1a3177' }, 
      {title: "Profit/View", color: '#ff9833' }
    ];
    
    return (
      <div>
        <XYPlot
          xType='ordinal'
          width={window.innerWidth - 50}
          height={400} 
        >
        <HorizontalGridLines />
        { (rev_plot) ? <VerticalBarSeries color='#12939a' data = {this.props.revenue_hash} /> : null }
        { (profit_plot) ? <VerticalBarSeries color='#79c7e3' data = {this.props.profit_hash} /> : null }
        { (rev_per_view_plot) ? <VerticalBarSeries color='#1a3177' data = {this.props.revenue_per_view_hash} /> : null }
        { (profit_per_view_plot) ? <VerticalBarSeries color='#ff9833' data = {this.props.profit_per_view_hash} /> : null }
        <XAxis title="Price Points"/>
        <YAxis title="$"/>
        </XYPlot>
        <DiscreteColorLegend items={plots} orientation='horizontal'/>
      </div>
    );
  }
}

