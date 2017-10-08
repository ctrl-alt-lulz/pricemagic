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
  }
  render() {
    return (<SettingToggle
              action={{content: 'Enable'}}
            >
              This setting is <TextStyle variation="strong">disabled</TextStyle>.
            </SettingToggle>
    );
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('settings-page')
ReactDOM.render(<SettingsPage />, node)
})
