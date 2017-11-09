import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import { Page, Layout, AccountConnection, SettingToggle, Button, TextStyle } from '@shopify/polaris';

export default class ConfigurationsPage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
    };
  }
  render() {
    return (
            <Page title="Configuration" >
            
              <Layout>
                 <Layout.AnnotatedSection
                    title="Seed"
                    description="Seed and Update Products"
                 >
                  <SettingToggle
                    action={{content: 'Update', url: '#', onAction: () => this.seedProducts() }}
                  >
                    This setting is <TextStyle variation="strong">disabled</TextStyle>.
                  </SettingToggle>
                </Layout.AnnotatedSection>
                <Layout.AnnotatedSection
                    title="Google Analytics Refresh"
                    description="Refresh Google Analytics."
                 >
                  <SettingToggle
                    action={{content: 'Update', url: '#', onAction: () => this.queryGoogle() }}
                  >
                    This setting is <TextStyle variation="strong">disabled</TextStyle>.
                  </SettingToggle>
                </Layout.AnnotatedSection>
                <Layout.AnnotatedSection
                    title="Update Price Tests"
                    description="price tests"
                 >
                  <SettingToggle
                    action={{content: 'Update', url: '#', onAction: () => this.updatePriceTests() }}
                  >
                    This setting is <TextStyle variation="strong">disabled</TextStyle>.
                  </SettingToggle>
                </Layout.AnnotatedSection>
              </Layout>
            </Page>
    );
  }

  seedProducts() {
    console.log(this.props.shop_id)
    console.log('seed')
    $.ajax( {
      url: '/seed_products_and_variants/',
      dataType: 'json',
      data: { id: this.props.shop_id },
      success: function(data) {
        console.log('success')
        this.setState({ products: data });
      }.bind(this),
      error: function(data) {
      }.bind(this)
    });
  }
  queryGoogle() {
    $.ajax( {
      url: '/query_google/',
      dataType: 'json',
      data: { id: this.props.shop_id },
      success: function(data) {
        console.log('success')
        this.setState({ products: data });
      }.bind(this),
      error: function(data) {
      }.bind(this)
    });
  }
  updatePriceTests() {
    $.ajax( {
      url: '/update_price_tests_statuses/',
      dataType: 'json',
      data: { id: this.props.shop_id },
      success: function(data) {
        console.log('success')
        this.setState({ products: data });
      }.bind(this),
      error: function(data) {
      }.bind(this)
    });
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('configurations-page')
  const data = JSON.parse(node.getAttribute('data'))
ReactDOM.render(<ConfigurationsPage {...data}/>, node)
})
