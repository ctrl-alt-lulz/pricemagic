import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import PriceTestForm from './PriceTestForm.js'
import { Page, Card, Select, Button, TextField, Stack, FormLayout,
Thumbnail, ResourceList, Pagination, Layout, Checkbox } from '@shopify/polaris';

export default class ProductShowPage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      percent_increase: '',
      percent_decrease: '',
      price_points: '1',
      end_digits: '99'
    };
    this.handlePercentIncreaseChange = this.handlePercentIncreaseChange.bind(this)
    this.handlePercentDecreaseChange = this.handlePercentDecreaseChange.bind(this)
    this.handlePricePointChange = this.handlePricePointChange.bind(this)
    this.handleEndDigitChange = this.handleEndDigitChange.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this);
  }
  handlePercentIncreaseChange(event) {
    this.setState({percent_increase: event}) 
  }
  handlePercentDecreaseChange(event) {
    this.setState({percent_decrease: event}) 
  }
  handlePricePointChange(event) {
    this.setState({price_points: event}) 
  }
  handleEndDigitChange(event) {
    this.setState({end_digits: event})
  }
  handleSubmit(event) {
    this.createPriceTest()
  }
  render() {
    const percent_increase = this.state.percent_increase
    const percent_decrease = this.state.percent_decrease
    const price_points = this.state.price_points
    const end_digits = this.state.end_digits
    
    return (<PriceTestForm 
              percent_increase = {percent_increase}
              percent_decrease = {percent_decrease}
              price_points = {price_points}
              end_digits = {end_digits}
              onPercentIncreaseChange = {this.handlePercentIncreaseChange} 
              onPercentDecreaseChange = {this.handlePercentDecreaseChange} 
              onPricePointChange = {this.handlePricePointChange}
              onEndDigitChange = {this.handleEndDigitChange}
              product = {this.props.product}
              onSubmitPriceTest = {this.handleSubmit}
            />
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
