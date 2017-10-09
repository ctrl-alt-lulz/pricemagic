import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import NativeListener from 'react-native-listener';

import { Page, Card, Select, Button, TextField, Stack, FormLayout,
Thumbnail, ResourceList, Pagination, Layout, Checkbox } from '@shopify/polaris';

export default class RecurringChargesLink extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
    };
    this.handleButtonClick = this.handleButtonClick.bind(this);
  }
  handleButtonClick (e) {
    e.preventDefault();
    e.stopPropagation();
    console.log('The link was clicked.');
    console.log('handleClick')
    console.log(event)
    this.createRecurringCharge()
  }
 
  render() {
    return (<div>
              <NativeListener onClick={this.handleButtonClick.bind(this)}>
                <a href="/recurring_charges" data-method="post">Rec. Charges Link</a>
              </NativeListener>
            </div>
    );
  }
  createRecurringCharge() {
    $.ajax( {
      type: "POST",
      dataType: "json",
      url: '/recurring_charges',
      data: {},
      success: function(response) {
        console.log('success');
        console.log(response);
        window.top.location.href = response.redirect_url 
      }.bind(this),
      error: function(response) {
        console.log('fail')
        console.log(response)
      }.bind(this)
    });
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('reccuring_charges')
ReactDOM.render(<RecurringChargesLink />, node)
})
