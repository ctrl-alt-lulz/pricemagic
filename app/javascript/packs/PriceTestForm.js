import React from 'react'
import ReactDOM from 'react-dom'

import PropTypes from 'prop-types'
import { Page, Card, Select, Button, TextField, Stack, FormLayout,
Thumbnail, ResourceList, Pagination, Layout, Checkbox } from '@shopify/polaris';

export default class PriceTestForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      percent_increase: '',
      percent_decrease: '',
      product: this.props.product,
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
  handleSubmit(event) {
    this.createPriceTest()
  }
  handlePricePointChange(event) {
    this.setState({price_points: event}) 
  }
  handleEndDigitChange(event) {
    this.setState({end_digits: event})
  }
    render () {
        return (<Card>
                  <FormLayout>
                    <FormLayout.Group>
                      <TextField 
                        value={this.state.percent_increase}
                        label="Percent Increase"
                        placeholder="Enter %"
                        onChange={this.handlePercentIncreaseChange}
                      />
                      <TextField 
                        value={this.state.percent_decrease}
                        label="Percent Decrease"
                        placeholder="Enter %"
                        onChange={this.handlePercentDecreaseChange}
                      />
                    </FormLayout.Group>
                    <FormLayout.Group>
                      <Select
                        value= {this.state.price_points}
                        label="Price Points"
                        options={ ['1', '2', '3', '4', '5'] }
                        placeholder="Select"
                        onChange={this.handlePricePointChange}
                      />
                      <Select
                        value= {this.state.end_digits}
                        label="Ending Digits"
                        options={ ['.99', '0.95', '0.50', '0.00'] }
                        placeholder="Select"
                        onChange={this.handleEndDigitChange}
                      />
                    </FormLayout.Group>
                    <Button primary onClick={this.handleSubmit}>Start Price Test</Button>
                 </FormLayout>
               </Card>);
    }
  createPriceTest() {
    $.ajax( {
      type: "POST",
      dataType: "json",
      url: '/price_tests',
      data: { price_test: { product_id: this.state.product.id, 
              shopify_product_id: this.state.product.shopify_id, 
              percent_increase: this.state.percent_increase, 
              percent_decrease: this.state.percent_decrease, 
              ending_digits: this.state.end_digits, 
              price_points: this.state.price_points } },
      success: function(data) {
        console.log('success')
        //this.setState({ products: data });
      }.bind(this),
      error: function(data) {
        console.log('failed')
      }.bind(this)
     });
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('polaris-price-test-form')
  const data = JSON.parse(node.getAttribute('data'))
ReactDOM.render(<PriceTestForm {...data}/>, node)
})
