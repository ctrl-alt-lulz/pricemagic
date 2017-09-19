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
      percent_increase: ''
    };
    this.handlePercentIncreaseChange = this.handlePercentIncreaseChange.bind(this)
  }
  handlePercentIncreaseChange(input) {
    this.setState({percent_increase: input}) 
  }
  render() {
    const percent_increase = this.state.percent_increase
    
    return (<PriceTestForm 
              percent_increase={percent_increase}
              onPercentIncreaseChange = {this.handlePercentIncreaseChange} 
            />
    );
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('product-page')
  const data= JSON.parse(node.getAttribute('data'))
ReactDOM.render(<ProductShowPage {...data}/>, node)
})
