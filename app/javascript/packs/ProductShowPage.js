import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import PriceTestForm from './PriceTestForm.js'
import PriceTestContainer from './PriceTestContainer.js'

import { Page, Card, Select, Button, TextField, Stack, FormLayout,
Thumbnail, ResourceList, Pagination, Layout, Checkbox } from '@shopify/polaris';

export default class ProductShowPage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      percent_increase: '',
      percent_decrease: '',
      price_points: '1',
      end_digits: 0.99, 
      price_multipler: [1]
    };
    this.handlePercentIncreaseChange = this.handlePercentIncreaseChange.bind(this)
    this.handlePercentDecreaseChange = this.handlePercentDecreaseChange.bind(this)
    this.handlePricePointChange = this.handlePricePointChange.bind(this)
    this.handleEndDigitChange = this.handleEndDigitChange.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this);
  }
  handlePercentIncreaseChange(event) {
    this.setState({percent_increase: event}, () => {
      this.CalcPriceMultipler()
    });
  }
  handlePercentDecreaseChange(event) {
    this.setState({percent_decrease: event}, () => {
      this.CalcPriceMultipler()
    });
  }
  handlePricePointChange(event) {
    this.setState({price_points: event}, () => {
      this.CalcPriceMultipler()
    });
  }
  handleEndDigitChange(event) {
    this.setState({end_digits: event})
  }
  handleSubmit(event) {
    this.createPriceTest()
  }
  CalcPriceMultipler() {
    var percent_increase = 1 + this.state.percent_increase/100
    var percent_decrease = 1 - this.state.percent_decrease/100
    var price_points = this.state.price_points
    var price_multipler = [percent_increase]
    
    if (price_points == 1) return this.setState({price_multipler: price_multipler}) 
    if (price_points == 2) {
      price_multipler.unshift(percent_decrease)
      return this.setState({price_multipler: price_multipler}) 
    } else {
      var step = (percent_increase-percent_decrease)/(price_points-1)
      for(var i = 1; i < (price_points -1); i++){
        price_multipler.unshift(price_multipler[i-1] - step*i) 
      } 
      price_multipler.unshift(percent_decrease)
      return this.setState({price_multipler: price_multipler}) 
    }
  }
  render() {
    const percent_increase = this.state.percent_increase
    const percent_decrease = this.state.percent_decrease
    const price_points = this.state.price_points
    const end_digits = this.state.end_digits
    const price_multipler = this.state.price_multipler
    
    return (<div>
            <PriceTestForm 
              percent_increase = {percent_increase}
              percent_decrease = {percent_decrease}
              price_points = {price_points}
              end_digits = {end_digits}
              onPercentIncreaseChange = {this.handlePercentIncreaseChange} 
              onPercentDecreaseChange = {this.handlePercentDecreaseChange} 
              onPricePointChange = {this.handlePricePointChange}
              onEndDigitChange = {this.handleEndDigitChange}
              onSubmitPriceTest = {this.handleSubmit}
            />
            <PriceTestContainer 
              price_test = {this.props.price_test}
              price_points = {price_points}
              price_multipler = {price_multipler}
              end_digits = {end_digits}
            />
            </div>
    );
  }
  createPriceTest() {
    $.ajax( {
      type: "POST",
      dataType: "json",
      url: '/price_tests',
      data: { price_test: { product_id: this.props.product.id, 
              shopify_product_id: this.props.product.shopify_id, 
              percent_increase: this.state.percent_increase, 
              percent_decrease: this.state.percent_decrease, 
              ending_digits: this.state.end_digits, 
              price_points: this.state.price_points } },
      success: function(data) {
        console.log('success')
        console.log(this.state.price_points)
        console.log(data)
        this.setState({ products: data });
      }.bind(this),
      error: function(data) {
        console.log('fail')
        console.log(data)
        console.log(this.state.price_points)
      }.bind(this)
    });
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('product-page')
  const data= JSON.parse(node.getAttribute('data'))
ReactDOM.render(<ProductShowPage {...data}/>, node)
})
