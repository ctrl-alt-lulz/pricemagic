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
    this.handleViewThresholdChange = this.handleViewThresholdChange.bind(this)
    this.handlePricePointChange = this.handlePricePointChange.bind(this)
    this.handleEndDigitChange = this.handleEndDigitChange.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleSubmitDestroy = this.handleSubmitDestroy.bind(this);
  }
  handlePercentIncreaseChange(event) {
    this.props.onPercentIncreaseChange(event)
  }
  handleViewThresholdChange(event) {
    this.props.onViewThresholdChange(event)
  }
  handlePercentDecreaseChange(event) {
    this.props.onPercentDecreaseChange(event)
  }
  handleSubmit(event) {
    this.props.onSubmitPriceTest()
  }
  handleSubmitDestroy(event) {
    this.props.onSubmitDestroyPriceTest()
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
    const price_test_active = this.props.price_test_active
    const view_threshold = this.props.view_threshold
      return (
              <Card.Section>
                <FormLayout>
                  <FormLayout.Group>
                    <TextField 
                      value={percent_increase}
                      label="Percent Increase"
                      placeholder="Enter %, i.e. 30"
                      type='number'
                      min="0"
                      onChange={this.handlePercentIncreaseChange}
                      disabled={price_test_active}
                    />
                    <TextField 
                      value={percent_decrease}
                      label="Percent Decrease"
                      placeholder="Enter % between 0 and 100, i.e. 50"
                      type='number'
                      min="0"
                      max="100"
                      onChange={this.handlePercentDecreaseChange}
                      disabled={price_test_active}
                    />
                    <TextField 
                      value={view_threshold}
                      label="View Threshold"
                      placeholder="Enter the number of views you want per price test"
                      type='number'
                      min="0"
                      onChange={this.handleViewThresholdChange}
                      disabled={price_test_active}
                    />
                  </FormLayout.Group>
                  <FormLayout.Group>
                    <Select
                      value= {price_points}
                      label="Price Points"
                      options={ ['1', '2', '3', '4', '5'] }
                      placeholder="Select"
                      onChange={this.handlePricePointChange}
                      disabled={price_test_active}
                    />
                    <Select
                      value= {end_digits}
                      label="Ending Digits"
                      options={ ['.99', '.95', '.50', '.00'] }
                      placeholder="Select"
                      onChange={this.handleEndDigitChange}
                      disabled={price_test_active}
                    />
                  </FormLayout.Group>
                  <FormLayout.Group>
                    <Button primary disabled={price_test_active}
                            onClick={this.handleSubmit}>Start Price Test</Button>
                    <Button primary onClick={this.handleSubmitDestroy}>Destroy Price Test</Button>
                  </FormLayout.Group>
               </FormLayout>
             </Card.Section>
              );
  }
}