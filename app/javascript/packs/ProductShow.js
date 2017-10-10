import React from 'react';
import ReactDOM from 'react-dom';
import PriceTestForm from './PriceTestForm.js';
import PriceTestContainer from './PriceTestContainer.js';
import LastPriceTestContainer from './LastPriceTestContainer.js';
import ProductGraphData from './ProductGraphData.js';
import { Page, Card, Select, Button, TextField, Stack, FormLayout, DisplayText,
Thumbnail, ResourceList, Pagination, Layout, Checkbox, Tabs } from '@shopify/polaris';

export default class ProductShow extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      percent_increase: '',
      percent_decrease: '',
      price_points: '1',
      end_digits: 0.99, 
      price_multipler: [1],
      final_plot: this.props.final_plot,
      variant_plot_data: this.props.variant_plot_data,
      plot_count: this.props.plot_count,
      plot_number: 0,
    };
    this.handlePercentIncreaseChange = this.handlePercentIncreaseChange.bind(this);
    this.handlePercentDecreaseChange = this.handlePercentDecreaseChange.bind(this);
    this.handleViewThresholdChange = this.handleViewThresholdChange.bind(this);
    this.handlePricePointChange = this.handlePricePointChange.bind(this);
    this.handleEndDigitChange = this.handleEndDigitChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleSubmitDestroy = this.handleSubmitDestroy.bind(this);
    this.toggleVariantPlotData = this.toggleVariantPlotData.bind(this);
  }
  handlePercentIncreaseChange(event) {
    this.setState({percent_increase: event}, () => {
      this.CalcPriceMultipler();
    });
  }
  handlePercentDecreaseChange(event) {
    this.setState({percent_decrease: event}, () => {
      this.CalcPriceMultipler();
    });
  }
  handleViewThresholdChange(event) {
    this.setState({view_threshold: event});
  }
  handlePricePointChange(event) {
    this.setState({price_points: event}, () => {
      this.CalcPriceMultipler();
    });
  }
  handleEndDigitChange(event) {
    this.setState({end_digits: event});
  }
  handleSubmit(event) {
    this.createPriceTest();
  }
  handleSubmitDestroy(event) {
    this.destroyPriceTest();
  }
  toggleVariantPlotData() {
    const plot_number = this.state.plot_number
    const plot_count = this.state.plot_count
    console.log(plot_number)
    if (plot_number == plot_count - 1)
    {
      this.setState({plot_number: 0}, () => {
      this.getNextPlot()
    });
    } else {
      this.setState({plot_number: plot_number + 1}, () => {
        this.getNextPlot()
      });
    }
  }
  getNextPlot() {
      const plot_number = this.state.plot_number
      this.setState({variant_plot_data: this.props.final_plot[plot_number]
    });
  }
  CalcPriceMultipler() {
    var percent_increase = 1 + this.state.percent_increase/100;
    var percent_decrease = 1 - this.state.percent_decrease/100;
    var price_points = this.state.price_points;
    var price_multipler = [percent_increase];

    if (price_points == 1) {
      return this.setState({price_multipler: price_multipler});
    } else if (price_points == 2) {
      price_multipler.unshift(percent_decrease);
      return this.setState({price_multipler: price_multipler}) ;
    } else {
      var step = (percent_increase-percent_decrease)/(price_points-1);
      for(var i = 1; i < (price_points -1); i++){
        price_multipler.unshift(price_multipler[i-1] - step*i) ;
      } 
      price_multipler.unshift(percent_decrease);
      return this.setState({price_multipler: price_multipler});
    }
  }
  render() {
    const percent_increase = this.state.percent_increase;
    const percent_decrease = this.state.percent_decrease;
    const price_points = this.state.price_points;
    const end_digits = this.state.end_digits;
    const price_multipler = this.state.price_multipler;
    const view_threshold = this.state.view_threshold;
    const product = this.props.product;
    const price_test_active = (this.props.product.has_active_price_test  == 'True');
    const price_test_data = this.props.price_test_data;
    const google_analytics_data = this.props.google_analytics_data;
    const variant_plot_data = this.state.variant_plot_data
    console.log(variant_plot_data)

    function PlotIfDataExists(props) {
      const dataExists = props.dataExists;
      console.log(dataExists)
      if(dataExists) {
        return (<div>
                  <ProductGraphData 
                    price_test_data = {price_test_data}
                    variant_plot_data = {variant_plot_data}
                  />
                  <Button onClick={props.toggleVariantPlotData}>Next Plot</Button>
                  <LastPriceTestContainer analytics_data = {variant_plot_data} />
                </div>
        );
      }
      return null;
    }
    
    return (<div>
              <DisplayText size="extraLarge">{product.title + '  '}</DisplayText>
              <PlotIfDataExists 
                dataExists={variant_plot_data} 
                toggleVariantPlotData={this.toggleVariantPlotData}
              />
              <PriceTestForm 
                percent_increase = {percent_increase}
                percent_decrease = {percent_decrease}
                price_points = {price_points}
                view_threshold = {view_threshold}
                end_digits = {end_digits}
                onPercentIncreaseChange = {this.handlePercentIncreaseChange} 
                onPercentDecreaseChange = {this.handlePercentDecreaseChange} 
                onViewThresholdChange = {this.handleViewThresholdChange}
                onPricePointChange = {this.handlePricePointChange}
                onEndDigitChange = {this.handleEndDigitChange}
                onSubmitPriceTest = {this.handleSubmit}
                onSubmitDestroyPriceTest = {this.handleSubmitDestroy}
                price_test_active = {price_test_active}
              />
              <PriceTestContainer 
                product = {product}
                price_points = {price_points}
                price_multipler = {price_multipler}
                end_digits = {end_digits}
              />
            </div>
    );
  }
  // TODO add javascript alert/flash for failure and show error message
  createPriceTest() {
    $.ajax( {
      type: "POST",
      dataType: "json",
      url: '/price_tests',
      data: { price_test: 
              { product_id: this.props.product.id, 
                shopify_product_id: this.props.product.shopify_id, 
                percent_increase: this.state.percent_increase, 
                percent_decrease: this.state.percent_decrease, 
                view_threshold: this.state.view_threshold,
                ending_digits: this.state.end_digits, 
                price_points: this.state.price_points 
              } 
            },
      success: function(data) {
        console.log(this.state.view_threshold);
        window.location = '/products/' + this.props.product.id;
      }.bind(this),
      error: function(data) {
        console.log('fail');
      }.bind(this)
    });
  }
  destroyPriceTest() {
    $.ajax( {
      type: "DELETE",
      dataType: "json",
      url: '/price_tests/' + this.props.price_test_data.id,
      success: function(data) {
        window.location = '/products/' + this.props.product.id;
      }.bind(this),
      error: function(data) {
        console.log('fail');
      }.bind(this)
    });
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('product-page');
  const data= JSON.parse(node.getAttribute('data'));
ReactDOM.render(<ProductShow {...data}/>, node);
});
