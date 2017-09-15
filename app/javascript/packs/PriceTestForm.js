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
      product: this.props.product
    };
    this.handlePercentIncreaseChange = this.handlePercentIncreaseChange.bind(this)
    this.handlePercentDecreaseChange = this.handlePercentDecreaseChange.bind(this)
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
                        value= '1' //{this.state.collection}
                        label="Price Points"
                        options={ ['1', '2', '3', '4', '5'] }
                        placeholder="Select"
                        //onChange={this.handleCollectionChange}
                      />
                      <Select
                        value= '0.99' //{this.state.collection}
                        label="Ending Digits"
                        options={ ['.99', '0.95', '0.50', '0.00'] }
                        placeholder="Select"
                        //onChange={this.handleCollectionChange}
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
              ending_digits: "0.99", 
              price_points: 1 } },
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
