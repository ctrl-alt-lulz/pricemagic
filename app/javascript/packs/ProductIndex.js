import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import PriceTestForm from './PriceTestForm.js'
import PriceTestContainer from './PriceTestContainer.js'
import ProductIndexTable from './ProductIndexTable.js'
import { Page, Card, Select, Button, TextField, Stack, FormLayout, Layout, Checkbox, 
        FooterHelp, ActionList, Popover, Link} from '@shopify/polaris';

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
      settings_toggle: false
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
    this.col_hash = this.props.collections.reduce(function ( total, current ) {
        total[ current.title ] = current.id;
        return total;
    }, {});
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
      collection: null
    }, () => {
      this.searchProducts()
    });
  }
  handleCollectionChange(event) {
    this.setState({
      collection_id: this.col_hash[event],
      collection: event,
      term: ''
    }, () => {
      this.searchProducts()
    });
  }
  handleSettingsToggle(){
    console.log('here')
  	this.setState({settings_toggle: !this.state.settings_toggle});
  }
  getSelectedProductIds() {
    const selected = this.state.selected
    return Object.keys(selected).filter(product => selected[product] == true)
                                .map(product => this.product_hash[product])
  }
  render() {
    const selected = this.state.selected
    const selectAll = this.state.selectAll
    const percent_increase = this.state.percent_increase;
    const percent_decrease = this.state.percent_decrease;
    const price_points = this.state.price_points;
    const end_digits = this.state.end_digits;
    const view_threshold = this.state.view_threshold;
    const settings_toggle = this.state.settings_toggle;
    const divStyle = {
      float: 'right',
      'margin-right' : '20px'
    };
    const divStyleIndex = {
      'margin-left': '20px'
    };
    const divStyleForm = {
      'margin-top': '35px'
    };
    function CollectionTitles(collection) {
      return collection.title
    }
    function DashboardActionList(props) {
      return(
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
            )
    }

    return (
      <div style={divStyleIndex}>
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
                  value= {this.state.collection}
                  label="Collection"
                  options={this.props.collections.map(CollectionTitles)}
                  placeholder="Select"
                  onChange={this.handleCollectionChange}
                />
              </FormLayout.Group>
            </FormLayout>
          </Card.Section>
          <Card.Section>
            <ProductIndexTable 
              products={this.state.products} 
              selected={selected}
              selectAll={selectAll}
              onToggleRow={this.toggleRow}
              onToggleSelectAll={this.toggleSelectAll}
            />
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
searchProducts() {
  $.ajax( {
    url: '/products/' + "?term=" + this.state.term + "&collection=" + this.state.collection_id,
    dataType: 'json',
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
        // TODO figure out why worker requests go to failure
      }.bind(this),
      error: function() {
        console.log('fail');
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
        // TODO figure out why worker requests go to failure
      }.bind(this),
      error: function() {
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

    
    