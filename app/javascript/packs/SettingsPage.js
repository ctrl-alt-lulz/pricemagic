import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import NativeListener from 'react-native-listener';

import { Page, Card, Select, Button, TextField, Stack, FormLayout, TextStyle,
Thumbnail, ResourceList, Pagination, Layout, Checkbox, SettingToggle } from '@shopify/polaris';

export default class SettingsPage extends React.Component {
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
    this.connectGoogleAnalytics()
  }
  render() {
    return (
            <Page title="Settings" >
              <Layout>
                <Layout.AnnotatedSection
                title="Google Analytics"
                description="Connect your Google Analytics Account"
                >
                <SettingToggle
                  action={{content: 'Enable'}}
                >
                This setting is <TextStyle variation="strong">disabled</TextStyle>.
                <NativeListener onClick={this.handleButtonClick.bind(this)}>
                  <a href="/google_auth" data-method="get">Goog Link</a>
                </NativeListener>
                </SettingToggle>
                </Layout.AnnotatedSection>
              </Layout>
            </Page>
    );
  }
  connectGoogleAnalytics() {
    $.ajax( {
      type: "GET",
      dataType: "json",
      url: '/google_auth',
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
  const node = document.getElementById('settings-page')
ReactDOM.render(<SettingsPage />, node)
})
