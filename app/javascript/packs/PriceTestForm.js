import React from 'react'
import ReactDOM from 'react-dom'

import PropTypes from 'prop-types'
import { Page, Card, Select, Button, TextField, Stack, FormLayout,
Thumbnail, ResourceList, Pagination, Layout, Checkbox } from '@shopify/polaris';

export default class PriceTestForm extends React.Component {
  constructor(props) {
    super(props);
    this.handlePercentIncreaseChange = this.handlePercentIncreaseChange.bind(this)
    this.handlePercentDecreaseChange = this.handlePercentDecreaseChange.bind(this)
    this.handlePricePointChange = this.handlePricePointChange.bind(this)
    this.handleEndDigitChange = this.handleEndDigitChange.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this);
  }
  handlePercentIncreaseChange(event) {
    this.props.onPercentIncreaseChange(event)
  }
  handlePercentDecreaseChange(event) {
    this.props.onPercentDecreaseChange(event)
  }
  handleSubmit(event) {
    this.props.onSubmitPriceTest()
  }
  handlePricePointChange(event) {
    this.props.onPricePointChange(event)
  }
  handleEndDigitChange(event) {
    this.props.onEndDigitChange(event)
  }
  render () {
    const percent_increase = this.props.percent_increase
    const percent_decrease = this.props.percent_decrease
    const price_points = this.props.price_points
    const end_digits = this.props.end_digits
    
      return (<Card>
                <FormLayout>
                  <FormLayout.Group>
                    <TextField 
                      value={percent_increase}
                      label="Percent Increase"
                      placeholder="Enter %, i.e. 30"
                      type='number'
                      onChange={this.handlePercentIncreaseChange}
                    />
                    <TextField 
                      value={percent_decrease}
                      label="Percent Decrease"
                      placeholder="Enter % between 0 and 100, i.e. 50"
                      type='number'
                      min="0"
                      max="100"
                      onChange={this.handlePercentDecreaseChange}
                    />
                  </FormLayout.Group>
                  <FormLayout.Group>
                    <Select
                      value= {price_points}
                      label="Price Points"
                      options={ ['1', '2', '3', '4', '5'] }
                      placeholder="Select"
                      onChange={this.handlePricePointChange}
                    />
                    <Select
                      value= {end_digits}
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
}