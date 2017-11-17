import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';
import PriceTestForm from './PriceTestForm.js';
import PriceTestContainer from './PriceTestContainer.js';
import ProductIndexTable from './ProductIndexTable.js';
import Joyride from 'react-joyride';
import { Card, Select, Button, TextField, FormLayout, Layout,  
        FooterHelp, ActionList, Popover } from '@shopify/polaris';

class ProductIndex extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      percent_increase: '',
      percent_decrease: '',
      price_points: '1',
      end_digits: 0.99, 
      term: '',
      collection_id: null,
      products: this.props.products,
      selected: {},
      selectAll: 0,
      settings_toggle: false,
    };
    this.handleSettingsToggle = this.handleSettingsToggle.bind(this);
    this.handleBulkSubmit = this.handleBulkSubmit.bind(this);
    this.handleBulkDestroySubmit = this.handleBulkDestroySubmit.bind(this);
    this.handlePercentIncreaseChange = this.handlePercentIncreaseChange.bind(this);
    this.handlePercentDecreaseChange = this.handlePercentDecreaseChange.bind(this);
    this.handleViewThresholdChange = this.handleViewThresholdChange.bind(this);
    this.handlePricePointChange = this.handlePricePointChange.bind(this);
    this.handleEndDigitChange = this.handleEndDigitChange.bind(this);
    this.handleTermChange = this.handleTermChange.bind(this);
    this.handleCollectionChange = this.handleCollectionChange.bind(this);
    this.toggleRow = this.toggleRow.bind(this);
    this.toggleSelectAll = this.toggleSelectAll.bind(this);
    this.product_hash = this.props.products.reduce(function ( total, current ) {
      total[ current.title ] = current.id;
      return total;
    }, {});
  }
  handlePercentIncreaseChange(event) {
    this.setState({percent_increase: event});
  }
  handlePercentDecreaseChange(event) {
    this.setState({percent_decrease: event});
  }
  handleViewThresholdChange(event) {
    this.setState({view_threshold: event});
  }
  handlePricePointChange(event) {
    this.setState({price_points: event});
  }
  handleEndDigitChange(event) {
    this.setState({end_digits: event});
  }
  handleBulkSubmit(event) {
    this.createBulkPriceTest();
  }
  handleBulkDestroySubmit(event) {
    this.destroyBulkPriceTest();
  }
  toggleRow(title) {
		const newSelected = Object.assign({}, this.state.selected);
		newSelected[title] = !this.state.selected[title];
		this.setState({
			selected: newSelected,
			selectAll: 2
		});
	}
	toggleSelectAll() {
		let newSelected = {};
		if (this.state.selectAll === 0) {
			this.state.products.forEach(product => {
				newSelected[product.title] = true;
			});
		}
		this.setState({
			selected: newSelected,
			selectAll: this.state.selectAll === 0 ? 1 : 0
		});
	}
  handleTermChange(event) {
    this.setState({
      term: event,
    }, () => {
      this.searchProducts()
    });
  }
  handleCollectionChange(event) {
    this.setState({
      collection_id: event,
      collection: event,
    }, () => {
      this.searchProducts()
    });
  }
  handleSettingsToggle(){
  	this.setState({settings_toggle: !this.state.settings_toggle});
  }
  getSelectedProductIds() {
    const selected = this.state.selected
    return Object.keys(selected).filter(product => selected[product] == true)
                                .map(product => this.product_hash[product])
  }
  render() {
    const {
      selected,
      selectAll,
      percent_increase,
      percent_decrease,
      price_points,
      end_digits,
      settings_toggle,
      view_threshold,
    } = this.state;
    const divStyle = {
      float: 'right',
      'marginRight' : '20px'
    };
    const divStyleIndex = {
      'marginLeft': '20px',
      'marginRight': '20px'
    };
    const divStyleForm = {
      'marginTop': '35px'
    };
    const steps = [{
                title: 'Trigger Action',
                text: 'It can be `click` (default) or `hover` <i>(reverts to click on touch devices</i>.',
                selector: '.joyride_step1',
                position: 'top',
                type: 'hover',
      }, {
                title: 'Product Index',
                text: 'It can be `click` (default) or `hover` <i>(reverts to click on touch devices</i>.',
                selector: '.joyride_step2',
                position: 'top',
                type: 'hover',
      }, {
                title: 'Prorr32r3 Index',
                text: 'It can be `click` (default) or `hover` <i>(reverts to click on touch devices</i>.',
                selector: '.joyride_step3',
                position: 'top',
                type: 'hover',
      }]
    function CollectionTitles(collection) {
      return {label: collection.title, value: collection.id}
    }
    function getCollectionOptions (collections) {
     const optionsArray =  collections.map(CollectionTitles)
     optionsArray.unshift({label: 'select', value: ''})
     return optionsArray;
    }
    function DashboardActionList(props) {
      return(
          <div className='joyride_step1'>
            <Popover 
              active={settings_toggle}
              activator={<Button onClick={props.handleSettingsToggle}>Settings</Button>}
            >
              <ActionList
                items={[
                  {content: 'Account', url: '/recurring_charges'},
                  {content: 'Configuration', url: '/configurations'}
                ]}
              />
            </Popover>
        </div>
            )
    }
    return (
      <div style={divStyleIndex}>
      <Joyride
        ref={c => (this.joyride = c)}
        steps={steps}
        run={true} // or some other boolean for when you want to start it
        debug={false}
        showStepsProgress={true}
        showSkipButton={true}
        type={'continuous'}
      />
      <Layout>
        <Layout.Section>
        <Card 
          title="Online store dashboard" 
          class="product_list" sectioned  
        >
        <div style={divStyle}>
        <DashboardActionList handleSettingsToggle={this.handleSettingsToggle} />
        </div>
          <div style={divStyleForm}>
          <div className='joyride_step3'>
          <PriceTestForm 
            percent_increase = {percent_increase}
            percent_decrease = {percent_decrease}
            price_points = {price_points}
            view_threshold = {view_threshold}
            end_digits = {end_digits}
            onPercentIncreaseChange = {this.handlePercentIncreaseChange} 
            onPercentDecreaseChange = {this.handlePercentDecreaseChange} 
            onViewThresholdChange = {this.handleViewThresholdChange}
            onPricePointChange = {this.handlePricePointChange}
            onEndDigitChange = {this.handleEndDigitChange}
            onSubmitPriceTest = {this.handleBulkSubmit}
            onSubmitDestroyPriceTest = {this.handleBulkDestroySubmit}
            price_test_active = {false}
          />
          </div>
          </div>
          <Card.Section>
            <FormLayout>
              <FormLayout.Group>
                <TextField 
                  value={this.state.term}
                  label="Keyword Search"
                  placeholder="Enter Term"
                  onChange={this.handleTermChange}
                />
                <Select
                  value={this.state.collection}
                  label="Collection"
                  options={getCollectionOptions(this.props.collections)}
                  placeholder="Select"
                  onChange={this.handleCollectionChange}
                />
              </FormLayout.Group>
            </FormLayout>
          </Card.Section>
          <Card.Section>
          <div className='joyride_step2'>
            <ProductIndexTable 
              products={this.state.products} 
              selected={selected}
              selectAll={selectAll}
              onToggleRow={this.toggleRow}
              onToggleSelectAll={this.toggleSelectAll}
            />
          </div>
          </Card.Section>
        </Card>
        </Layout.Section>
        <Layout.Section>
          <FooterHelp>
             The Lannister Group LLC © 2017
          </FooterHelp>
        </Layout.Section>
      </Layout>
      </div>
    );  
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
  searchProducts() {
    $.ajax( {
      url: '/products/',
      dataType: 'json',
      data: { term: this.state.term, collection: this.state.collection_id },
      success: function(data) {
        this.setState({ products: data });
      }.bind(this),
      error: function(data) {
      }.bind(this)
    });
  }
  createBulkPriceTest() {
    $.ajax( {
      type: "POST",
      dataType: "json",
      url: '/price_tests/bulk_create',
      data: { price_test: 
              { product_ids: this.getSelectedProductIds(),
                percent_increase: this.state.percent_increase, 
                percent_decrease: this.state.percent_decrease, 
                view_threshold: this.state.view_threshold,
                ending_digits: this.state.end_digits, 
                price_points: this.state.price_points 
              } 
            },
      success: function() {
        console.log('success');
        window.location = '/'
      }.bind(this),
      error: function() {
        console.log('fail');
        window.location = '/'
      }.bind(this)
    });
  }
  destroyBulkPriceTest() {
    $.ajax( {
      type: "DELETE",
      dataType: "json",
      url: '/price_tests/bulk_destroy',
      data: { product_ids: this.getSelectedProductIds() },
      success: function() {
        console.log('success');
        window.location = '/'
      }.bind(this),
      error: function() {
        window.location = '/'
        console.log('fail');
      }.bind(this)
    });
  }
}
  
document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('product-index-page')
  const data = JSON.parse(node.getAttribute('data'))
ReactDOM.render(<ProductIndex {...data}/>, node)
})

    
    